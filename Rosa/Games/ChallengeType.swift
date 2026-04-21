import SwiftUI

// MARK: - Challenge Models

enum ChallengeType {
    case figure(FigureChallenge)
    case rhyme(RhymeChallenge)
    case scramble(ScrambleChallenge)
    case author(AuthorMatchChallenge)
    case missingWord(MissingWordChallenge) // NEW
    case theme(ThemeChallenge)             // NEW
}

struct FigureChallenge {
    let verse: String
    let correct: RhetoricalFigure
    let options: [RhetoricalFigure]
    let poemTitle: String
}

struct RhymeChallenge {
    let target: String
    let correct: String
    let options: [String]
    let poemTitle: String
}

struct ScrambleChallenge {
    let original: [String]
    var current: [String]
    let poemTitle: String
}

struct AuthorMatchChallenge {
    let author: String
    let correctVerse: String
    let options: [String]
}

struct MissingWordChallenge {
    let verseWithBlank: String
    let correctWord: String
    let options: [String]
    let poemTitle: String
}

struct ThemeChallenge {
    let poemTitle: String
    let author: String
    let correctTheme: String
    let options: [String]
}

// MARK: - Main Game View

/// A unified "Survival Mode" game where users face random poetry challenges until they lose 3 lives.
struct PoetsTrialView: View {
    let poems: [Poem]
    @Environment(\.dismiss) private var dismiss
    
    // Persistent Records
    @AppStorage("rosesChallengeHighScore") private var highScore: Int = 0
    let rosesRecord: Int = 150
    
    // Game State
    @State private var lives: Int = 3
    @State private var score: Int = 0
    @State private var activeChallenge: ChallengeType? = nil
    @State private var isGameOver: Bool = false
    @State private var newRecordAchieved: Bool = false
    @State private var beatRose: Bool = false
    
    // Feedback State
    @State private var feedbackColor: Color = .clear
    @State private var showFeedback: Bool = false
    
    // Styling
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    let goldColor = Color(red: 0.85, green: 0.75, blue: 0.4)
    
    var body: some View {
        ZStack {
            parchmentColor.ignoresSafeArea()
            
            if isGameOver {
                gameOverScreen
            } else if let challenge = activeChallenge {
                VStack(spacing: 24) {
                    headerView
                    
                    ScrollView {
                        // Challenge Content
                        switch challenge {
                        case .figure(let data):
                            figureChallengeView(data: data)
                        case .rhyme(let data):
                            rhymeChallengeView(data: data)
                        case .scramble(let data):
                            scrambleChallengeView(data: data)
                        case .author(let data):
                            authorChallengeView(data: data)
                        case .missingWord(let data):
                            missingWordChallengeView(data: data)
                        case .theme(let data):
                            themeChallengeView(data: data)
                        }
                    }
                }
            } else {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(cordovanColor)
                    Text("Preparing the trial...")
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(cordovanColor)
                }
                .onAppear(perform: generateNextChallenge)
            }
            
            // Full screen flash for correct/incorrect answers
            if showFeedback {
                feedbackColor.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Header UI
    
    private var headerView: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(cordovanColor)
                    .padding(12)
                    .background(Color.white.opacity(0.5))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(cordovanColor.opacity(0.2), lineWidth: 1))
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("SCORE")
                    .font(.system(size: 10, weight: .bold, design: .serif))
                    .tracking(2)
                    .foregroundColor(.secondary)
                Text("\(score)")
                    .font(.system(.title2, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(cordovanColor)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < lives ? "heart.fill" : "heart")
                        .foregroundColor(i < lives ? .red : .gray.opacity(0.5))
                        .font(.title2)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
    
    // MARK: - Challenge Sub-Views
    
    private func figureChallengeView(data: FigureChallenge) -> some View {
        VStack(spacing: 32) {
            instructionCard(title: "Identify the Figure", subtitle: "Which rhetorical figure is used here?", verse: data.verse, context: data.poemTitle)
            
            VStack(spacing: 16) {
                ForEach(data.options, id: \.self) { figure in
                    Button(action: { handleAnswer(isCorrect: figure == data.correct) }) {
                        gameButtonText(figure.italianName)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func rhymeChallengeView(data: RhymeChallenge) -> some View {
        VStack(spacing: 32) {
            instructionCard(title: "Find the Rhyme", subtitle: "Which verse rhymes with this one?", verse: data.target, context: data.poemTitle)
            
            VStack(spacing: 16) {
                ForEach(data.options, id: \.self) { option in
                    Button(action: { handleAnswer(isCorrect: option == data.correct) }) {
                        gameButtonText(option)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func authorChallengeView(data: AuthorMatchChallenge) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                Image(systemName: "quill")
                    .font(.system(size: 30))
                    .foregroundColor(goldColor)
                
                Text("The Author's Archive")
                    .font(.system(.title2, design: .serif).bold())
                    .foregroundColor(cordovanColor)
                
                Text("Identify the original manuscript written by:")
                    .font(.subheadline)
                    .foregroundColor(cordovanColor.opacity(0.7))
                
                Text(data.author)
                    .font(.system(size: 28, weight: .heavy, design: .serif))
                    .foregroundColor(cordovanColor)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .background(Color.white.opacity(0.4))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(cordovanColor.opacity(0.15), lineWidth: 1))
            .padding(.horizontal, 24)
            
            VStack(spacing: 16) {
                ForEach(data.options, id: \.self) { verse in
                    Button(action: { handleAnswer(isCorrect: verse == data.correctVerse) }) {
                        Text("\"\(verse)\"")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(Color.white.opacity(0.7))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(goldColor.opacity(0.8), style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                            )
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 2)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func scrambleChallengeView(data: ScrambleChallenge) -> some View {
        VStack(spacing: 24) {
            instructionCard(title: "Verse Scramble", subtitle: "Drag to reorder these verses correctly.", verse: nil, context: data.poemTitle)
            
            ScrambleListWrapper(items: data.current) { newOrder in
                let isCorrect = newOrder == data.original
                handleAnswer(isCorrect: isCorrect)
            }
        }
    }
    
    private func missingWordChallengeView(data: MissingWordChallenge) -> some View {
        VStack(spacing: 32) {
            instructionCard(title: "Fill in the Blank", subtitle: "Which word completes the verse?", verse: data.verseWithBlank, context: data.poemTitle)
            
            VStack(spacing: 16) {
                ForEach(data.options, id: \.self) { word in
                    Button(action: { handleAnswer(isCorrect: word == data.correctWord) }) {
                        gameButtonText(word.uppercased())
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private func themeChallengeView(data: ThemeChallenge) -> some View {
        VStack(spacing: 32) {
            instructionCard(title: "Thematic Match", subtitle: "What is the primary theme of this poem?", verse: nil, context: "\(data.poemTitle) by \(data.author)")
            
            VStack(spacing: 16) {
                ForEach(data.options, id: \.self) { theme in
                    Button(action: { handleAnswer(isCorrect: theme == data.correctTheme) }) {
                        gameButtonText(theme.uppercased())
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Reusable UI Components
    
    private func instructionCard(title: String, subtitle: String, verse: String?, context: String) -> some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(.title2, design: .serif).bold())
                    .foregroundColor(cordovanColor)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(cordovanColor.opacity(0.7))
            }
            
            if let v = verse {
                Text(v.contains("_____") ? v : "\"\(v)\"")
                    .font(.system(size: 22, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black.opacity(0.85))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(8)
            }
            
            Text("From: \(context)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(cordovanColor.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.white.opacity(0.4)) // Paper feel
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(goldColor.opacity(0.5), lineWidth: 2)
                .padding(4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(cordovanColor.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: cordovanColor.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 24)
    }
    
    private func gameButtonText(_ text: String) -> some View {
        Text(text)
            .font(.system(.headline, design: .serif))
            .foregroundColor(parchmentColor)
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: .infinity, minHeight: 60)
            .background(cordovanColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(goldColor.opacity(0.6), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
    }
    
    private var gameOverScreen: some View {
        VStack(spacing: 24) {
            if beatRose {
                Image(systemName: "crown.fill")
                    .font(.system(size: 80))
                    .foregroundColor(goldColor)
                Text("Legendary!")
                    .font(.system(.largeTitle, design: .serif).bold())
                    .foregroundColor(cordovanColor)
                Text("You have beaten Rose's unbreakable record.")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else if newRecordAchieved {
                Image(systemName: "star.fill")
                    .font(.system(size: 80))
                    .foregroundColor(goldColor)
                Text("New Personal Best!")
                    .font(.system(.largeTitle, design: .serif).bold())
                    .foregroundColor(cordovanColor)
                Text("You are getting closer to Rose's record (\(rosesRecord)).")
                    .font(.headline)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "heart.slash.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.red.opacity(0.8))
                Text("The Trial Ends")
                    .font(.system(.largeTitle, design: .serif).bold())
                    .foregroundColor(cordovanColor)
                Text("Rose's record (\(rosesRecord)) remains unbroken.")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text("\(score)")
                .font(.system(size: 80, weight: .heavy, design: .serif))
                .foregroundColor(goldColor)
                .shadow(color: cordovanColor.opacity(0.3), radius: 4, x: 0, y: 4)
            
            VStack(spacing: 16) {
                Button(action: {
                    score = 0
                    lives = 3
                    isGameOver = false
                    newRecordAchieved = false
                    beatRose = false
                    generateNextChallenge()
                }) {
                    Text("Try Again")
                        .font(.system(.headline, design: .serif).bold())
                        .foregroundColor(parchmentColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(cordovanColor)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(goldColor.opacity(0.5), lineWidth: 1))
                }
                
                Button(action: { dismiss() }) {
                    Text("Return to Menu")
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(cordovanColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 40)
            .padding(.top, 32)
        }
    }
    
    // MARK: - Game Logic & Generators
    
    private func handleAnswer(isCorrect: Bool) {
        let impact = UIImpactFeedbackGenerator(style: isCorrect ? .light : .heavy)
        impact.impactOccurred()
        
        withAnimation {
            feedbackColor = isCorrect ? .green : .red
            showFeedback = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation {
                showFeedback = false
                if isCorrect {
                    score += 10
                    generateNextChallenge()
                } else {
                    lives -= 1
                    if lives <= 0 {
                        finishGame()
                    } else {
                        generateNextChallenge()
                    }
                }
            }
        }
    }
    
    private func finishGame() {
        if score > highScore {
            highScore = score
            newRecordAchieved = true
        }
        if score > rosesRecord {
            beatRose = true
        }
        isGameOver = true
    }
    
    private func generateNextChallenge() {
        let generators: [() -> ChallengeType?] = [
            { generateFigureChallenge() },
            { generateRhymeChallenge() },
            { generateScrambleChallenge() },
            { generateAuthorChallenge() },
            { generateMissingWordChallenge() },
            { generateThemeChallenge() }
        ]
        
        for generator in generators.shuffled() {
            if let challenge = generator() {
                activeChallenge = challenge
                return
            }
        }
    }
    
    private func generateFigureChallenge() -> ChallengeType? {
        let eligible = poems.filter { !$0.figures.isEmpty }
        guard let poem = eligible.randomElement(), let (index, figure) = poem.figures.randomElement() else { return nil }
        
        let options = RhetoricalFigure.allCases.filter { $0 != figure }.shuffled().prefix(2)
        let finalOptions = (Array(options) + [figure]).shuffled()
        
        return .figure(FigureChallenge(verse: poem.verses[index], correct: figure, options: finalOptions, poemTitle: poem.title))
    }
    
    private func generateRhymeChallenge() -> ChallengeType? {
        let eligible = poems.filter { $0.metrics?.hasRhyme == true }
        guard let poem = eligible.randomElement() else { return nil }
        
        for i in 0..<poem.verses.count {
            for j in (i+1)..<poem.verses.count {
                if poem.verses[i].identifiesRhyme(with: poem.verses[j]) {
                    let target = poem.verses[i]
                    let correct = poem.verses[j]
                    
                    var distractors = poem.verses.filter { $0 != target && $0 != correct && !$0.identifiesRhyme(with: target) }
                    distractors.shuffle()
                    let wrong = Array(distractors.prefix(1))
                    
                    return .rhyme(RhymeChallenge(target: target, correct: correct, options: ([correct] + wrong).shuffled(), poemTitle: poem.title))
                }
            }
        }
        return nil
    }
    
    private func generateScrambleChallenge() -> ChallengeType? {
        guard let poem = poems.randomElement(), let stanzaIndices = poem.stanzas.randomElement(), stanzaIndices.count >= 2 else { return nil }
        
        let original = Array(stanzaIndices.map { poem.verses[$0] }.prefix(3))
        var shuffled = original.shuffled()
        while shuffled == original && original.count > 1 { shuffled = original.shuffled() }
        
        return .scramble(ScrambleChallenge(original: original, current: shuffled, poemTitle: poem.title))
    }
    
    private func generateAuthorChallenge() -> ChallengeType? {
        guard let correctPoem = poems.randomElement(), let correctVerse = correctPoem.verses.first else { return nil }
        let correctAuthor = correctPoem.author
        
        let otherPoems = poems.filter { $0.author != correctAuthor }
        var distractors: [String] = []
        var usedAuthors: Set<String> = [correctAuthor]
        
        for poem in otherPoems.shuffled() {
            if !usedAuthors.contains(poem.author), let verse = poem.verses.first {
                distractors.append(verse)
                usedAuthors.insert(poem.author)
            }
            if distractors.count == 2 { break }
        }
        
        let options = (distractors + [correctVerse]).shuffled()
        return .author(AuthorMatchChallenge(author: correctAuthor, correctVerse: correctVerse, options: options))
    }
    
    private func generateMissingWordChallenge() -> ChallengeType? {
        guard let poem = poems.randomElement(), let verse = poem.verses.randomElement() else { return nil }
        
        // Find a suitable word to remove (more than 4 letters, strip punctuation)
        let words = verse.split(separator: " ").map { String($0).trimmingCharacters(in: .punctuationCharacters) }
        let suitableWords = words.filter { $0.count > 4 }
        guard let targetWord = suitableWords.randomElement() else { return nil }
        
        // Replace word with blank, keeping punctuation intact if possible
        let verseWithBlank = verse.replacingOccurrences(of: targetWord, with: "_____")
        if verseWithBlank == verse { return nil } // Failsafe
        
        // Find distractors from other verses
        let allWords = poems.flatMap { $0.verses.flatMap { $0.split(separator: " ").map { String($0).trimmingCharacters(in: .punctuationCharacters) } } }
        let otherWords = Array(Set(allWords.filter { $0.count > 4 && $0 != targetWord && $0.lowercased() != targetWord.lowercased() }))
        let distractors = Array(otherWords.shuffled().prefix(2))
        
        let options = (distractors + [targetWord]).shuffled()
        return .missingWord(MissingWordChallenge(verseWithBlank: verseWithBlank, correctWord: targetWord, options: options, poemTitle: poem.title))
    }
    
    private func generateThemeChallenge() -> ChallengeType? {
        let eligible = poems.filter { !$0.themes.isEmpty }
        guard let poem = eligible.randomElement(), let correctTheme = poem.themes.randomElement() else { return nil }
        
        let allThemes = Array(Set(poems.flatMap { $0.themes }))
        let availableDistractors = allThemes.filter { $0 != correctTheme }
        let distractors = Array(availableDistractors.shuffled().prefix(2))
        
        let options = (distractors + [correctTheme]).shuffled()
        return .theme(ThemeChallenge(poemTitle: poem.title, author: poem.author, correctTheme: correctTheme, options: options))
    }
}

/// A wrapper to handle the List and onMove mechanics seamlessly inside the unified scroll view.
struct ScrambleListWrapper: View {
    @State var items: [String]
    let onSubmit: ([String]) -> Void
    
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    let goldColor = Color(red: 0.85, green: 0.75, blue: 0.4)
    
    var body: some View {
        VStack {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.system(.body, design: .serif))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .padding(.vertical, 8)
                        .listRowBackground(Color.white.opacity(0.6)) // Parchment row look
                        .listRowSeparatorTint(cordovanColor.opacity(0.2))
                }
                .onMove { source, destination in
                    items.move(fromOffsets: source, toOffset: destination)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden) // Hides default iOS list gray background
            .environment(\.editMode, .constant(.active))
            .frame(height: CGFloat(items.count * 60) + 20) // Dynamic height
            .background(Color.white.opacity(0.4))
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(cordovanColor.opacity(0.1), lineWidth: 1))
            .padding(.horizontal, 24)
            
            Button(action: { onSubmit(items) }) {
                Text("Submit Order")
                    .font(.system(.headline, design: .serif).bold())
                    .foregroundColor(Color(red: 0.95, green: 0.93, blue: 0.88))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(cordovanColor)
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(goldColor.opacity(0.6), lineWidth: 1))
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
        }
    }
}
