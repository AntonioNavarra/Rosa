import SwiftUI

/// A creative workspace where users can write their own Italian poetry
/// with real-time metrical analysis, an intelligent offline assistant, and persistent saving.
struct PoetryEditorView: View {
    @State private var title: String = ""
    @State private var verses: [String] = [""]
    @State private var syllableCounts: [Int] = [0]
    
    // Store the active Task to allow debouncing
    @State private var analysisTask: Task<Void, Never>?
    
    // Muse Assistant State
    @State private var isMuseThinking: Bool = false
    private let museModel = OnDeviceMuseModel() // 100% Offline Scaffolding Model
    
    // Persistence State
    @State private var savedPoems: [SavedPoem] = []
    @State private var showArchive: Bool = false
    @State private var showSaveConfirmation: Bool = false
    
    // Fallback basic analyzer for counting syllables in the playground
    private let analyzer = BasicPoemAnalyzer()
    
    // Classic Theme Colors
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    let inkColor = Color(red: 0.15, green: 0.15, blue: 0.15)
    let goldColor = Color(red: 0.85, green: 0.75, blue: 0.4)
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Antique background
                parchmentColor.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // Classic Header
                    VStack(spacing: 8) {
                        Text("❧")
                            .font(.system(size: 24, design: .serif))
                            .foregroundColor(cordovanColor)
                        
                        Text("La Bottega")
                            .font(.system(size: 32, weight: .heavy, design: .serif))
                            .foregroundColor(inkColor)
                            .tracking(1.5)
                        
                        Text("Compose verses and use The Muse for structural inspiration.")
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    // Manuscript Area
                    VStack(spacing: 0) {
                        // Title Input
                        TextField("Title of your masterpiece...", text: $title)
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(cordovanColor)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.white.opacity(0.5))
                        
                        Divider()
                            .background(cordovanColor.opacity(0.2))
                        
                        // Verses List (Styled as Ruled Parchment)
                        List {
                            ForEach(0..<verses.count, id: \.self) { index in
                                HStack(alignment: .center, spacing: 12) {
                                    // Syllable count badge styled like a classic wax seal
                                    Text("\(syllableCounts[index])")
                                        .font(.system(.caption, design: .serif).bold())
                                        .foregroundColor(.white)
                                        .frame(width: 28, height: 28)
                                        .background(getBadgeColor(for: syllableCounts[index]))
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white.opacity(0.6), lineWidth: 1))
                                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    
                                    TextField("Write a verse...", text: Binding(
                                        get: { verses[index] },
                                        set: { newValue in
                                            verses[index] = newValue
                                            debouncedAnalyze(index: index, text: newValue)
                                        }
                                    ))
                                    .font(.system(size: 20, design: .serif))
                                    .italic()
                                    .foregroundColor(inkColor)
                                    .padding(.vertical, 8)
                                }
                                .listRowBackground(Color.white.opacity(0.6))
                                .listRowSeparatorTint(cordovanColor.opacity(0.2))
                            }
                            .onDelete(perform: deleteVerse)
                            .onMove(perform: moveVerse)
                            
                            // Add Verse Button
                            Button(action: addVerse) {
                                HStack {
                                    Image(systemName: "pencil.and.outline")
                                    Text("Add Verse")
                                }
                                .font(.system(.headline, design: .serif).bold())
                                .foregroundColor(cordovanColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                            }
                            .listRowBackground(Color.white.opacity(0.4))
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .environment(\.editMode, .constant(.active))
                    }
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(cordovanColor.opacity(0.15), lineWidth: 1))
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // The Intelligent Muse Toolbar
                    museAssistantToolbar
                }
                
                // Loading Overlay for "Thinking" state
                if isMuseThinking {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 20) {
                        Image(systemName: "text.book.closed")
                            .font(.system(size: 40))
                            .foregroundColor(goldColor)
                        
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(goldColor)
                        
                        Text("The Muse is reading your verses...")
                            .font(.system(.headline, design: .serif))
                            .foregroundColor(parchmentColor)
                    }
                    .padding(40)
                    .background(cordovanColor)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(goldColor.opacity(0.5), lineWidth: 2))
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                }
                
                // Save Confirmation Overlay
                if showSaveConfirmation {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 50))
                            .foregroundColor(goldColor)
                        Text("Masterpiece Saved")
                            .font(.system(.title2, design: .serif).bold())
                            .foregroundColor(parchmentColor)
                    }
                    .padding(32)
                    .background(cordovanColor.opacity(0.95))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showArchive = true }) {
                        HStack(spacing: 4) {
                            Image(systemName: "archivebox.fill")
                            Text("My Archive")
                        }
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(cordovanColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveCurrentPoem) {
                        HStack(spacing: 4) {
                            Text("Save")
                            Image(systemName: "square.and.arrow.down.fill")
                        }
                        .font(.system(.headline, design: .serif).bold())
                        .foregroundColor(cordovanColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(goldColor.opacity(0.3))
                        .cornerRadius(8)
                    }
                    // Disable save if the poem is empty
                    .disabled(verses.allSatisfy { $0.trimmingCharacters(in: .whitespaces).isEmpty })
                }
            }
            .sheet(isPresented: $showArchive) {
                UserArchiveView(savedPoems: $savedPoems, onSelect: loadPoem)
            }
            .onAppear(perform: loadSavedPoems)
        }
    }
    
    // MARK: - Persistence Logic
    
    private func loadSavedPoems() {
        if let data = UserDefaults.standard.data(forKey: "savedUserPoems"),
           let decoded = try? JSONDecoder().decode([SavedPoem].self, from: data) {
            savedPoems = decoded.sorted(by: { $0.date > $1.date })
        }
    }
    
    private func saveCurrentPoem() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        let newTitle = title.trimmingCharacters(in: .whitespaces).isEmpty ? "Untitled Masterpiece" : title
        let meaningfulVerses = verses.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        let newPoem = SavedPoem(id: UUID(), title: newTitle, verses: meaningfulVerses, date: Date())
        
        // Save to array and persist to UserDefaults
        savedPoems.insert(newPoem, at: 0)
        if let encoded = try? JSONEncoder().encode(savedPoems) {
            UserDefaults.standard.set(encoded, forKey: "savedUserPoems")
        }
        
        // Show confirmation
        withAnimation(.spring()) { showSaveConfirmation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showSaveConfirmation = false }
        }
    }
    
    private func loadPoem(_ poem: SavedPoem) {
        title = poem.title
        verses = poem.verses.isEmpty ? [""] : poem.verses
        
        // Re-analyze meter for loaded verses
        syllableCounts = verses.map { analyzer.analyzeMeter(verses: [$0]).first ?? 0 }
    }
    
    // MARK: - The Muse UI & Actions
    
    private var museAssistantToolbar: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(goldColor)
                Text("Contextual Inspiration")
                    .font(.system(.subheadline, design: .serif).bold())
                    .foregroundColor(cordovanColor)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    MuseActionButton(icon: "text.quote", title: "Metaphor") {
                        generateWithMuse(intent: .metaphor)
                    }
                    
                    MuseActionButton(icon: "leaf.fill", title: "Simile") {
                        generateWithMuse(intent: .simile)
                    }
                    
                    MuseActionButton(icon: "person.wave.2.fill", title: "Personification") {
                        generateWithMuse(intent: .personification)
                    }
                    
                    MuseActionButton(icon: "bolt.fill", title: "Hyperbole") {
                        generateWithMuse(intent: .hyperbole)
                    }
                    
                    MuseActionButton(icon: "arrow.left.and.right", title: "Oxymoron") {
                        generateWithMuse(intent: .oxymoron)
                    }
                    
                    MuseActionButton(icon: "eye.fill", title: "Sensory") {
                        generateWithMuse(intent: .sensory)
                    }
                    
                    MuseActionButton(icon: "link", title: "Find Rhyme") {
                        generateWithMuse(intent: .rhyme)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white.opacity(0.7))
        .overlay(Rectangle().stroke(cordovanColor.opacity(0.15), lineWidth: 1).edgesIgnoringSafeArea(.bottom))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -2)
        .disabled(isMuseThinking)
    }
    
    private func generateWithMuse(intent: OnDeviceMuseModel.Intent) {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        withAnimation {
            isMuseThinking = true
        }
        
        Task {
            let suggestion = await museModel.generateSuggestion(for: verses, intent: intent)
            
            await MainActor.run {
                withAnimation {
                    if let last = verses.last, last.isEmpty {
                        verses[verses.count - 1] = suggestion
                        debouncedAnalyze(index: verses.count - 1, text: suggestion)
                    } else {
                        verses.append(suggestion)
                        syllableCounts.append(0)
                        debouncedAnalyze(index: verses.count - 1, text: suggestion)
                    }
                    isMuseThinking = false
                }
            }
        }
    }
    
    // MARK: - Performance Optimized Logic
    
    private func debouncedAnalyze(index: Int, text: String) {
        analysisTask?.cancel()
        
        analysisTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            
            let count = analyzer.analyzeMeter(verses: [text]).first ?? 0
            
            await MainActor.run {
                if syllableCounts.indices.contains(index) {
                    syllableCounts[index] = count
                }
            }
        }
    }
    
    private func addVerse() {
        withAnimation {
            verses.append("")
            syllableCounts.append(0)
        }
    }
    
    private func deleteVerse(at offsets: IndexSet) {
        verses.remove(atOffsets: offsets)
        syllableCounts.remove(atOffsets: offsets)
    }
    
    private func moveVerse(from source: IndexSet, to destination: Int) {
        verses.move(fromOffsets: source, toOffset: destination)
        syllableCounts.move(fromOffsets: source, toOffset: destination)
    }
    
    private func getBadgeColor(for count: Int) -> Color {
        if count == 0 { return Color(red: 0.6, green: 0.55, blue: 0.5) }
        if count == 11 { return Color(red: 0.2, green: 0.45, blue: 0.2) } // Endecasillabo
        if count == 7 { return Color(red: 0.2, green: 0.35, blue: 0.5) } // Settenario
        return cordovanColor // Incorrect meter
    }
}

// MARK: - Archive View

/// A modal view displaying the user's previously saved poetry.
struct UserArchiveView: View {
    @Binding var savedPoems: [SavedPoem]
    let onSelect: (SavedPoem) -> Void
    @Environment(\.dismiss) private var dismiss
    
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    
    var body: some View {
        NavigationView {
            ZStack {
                parchmentColor.ignoresSafeArea()
                
                if savedPoems.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "quill")
                            .font(.system(size: 60))
                            .foregroundColor(cordovanColor.opacity(0.5))
                        Text("Your archive is empty.")
                            .font(.system(.title2, design: .serif))
                            .foregroundColor(cordovanColor)
                        Text("Write and save your first masterpiece to see it here.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(savedPoems) { poem in
                            Button(action: {
                                onSelect(poem)
                                dismiss()
                            }) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(poem.title)
                                        .font(.system(.headline, design: .serif).bold())
                                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                                    Text(poem.verses.first ?? "")
                                        .font(.system(.subheadline, design: .serif))
                                        .italic()
                                        .foregroundColor(.secondary)
                                        .lineLimit(1)
                                    Text(poem.date, style: .date)
                                        .font(.caption)
                                        .foregroundColor(cordovanColor.opacity(0.7))
                                }
                                .padding(.vertical, 4)
                            }
                            .listRowBackground(Color.white.opacity(0.6))
                        }
                        .onDelete(perform: deletePoem)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("My Archive")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(cordovanColor)
                }
            }
        }
    }
    
    private func deletePoem(at offsets: IndexSet) {
        savedPoems.remove(atOffsets: offsets)
        if let encoded = try? JSONEncoder().encode(savedPoems) {
            UserDefaults.standard.set(encoded, forKey: "savedUserPoems")
        }
    }
}

// MARK: - Models & Components

struct SavedPoem: Codable, Identifiable {
    let id: UUID
    let title: String
    let verses: [String]
    let date: Date
}

struct MuseActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.system(.subheadline, design: .serif).bold())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(red: 0.25, green: 0.10, blue: 0.10)) // Cordovan background
            .foregroundColor(Color(red: 0.95, green: 0.93, blue: 0.88)) // Parchment text
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(red: 0.85, green: 0.75, blue: 0.4).opacity(0.8), lineWidth: 1.5))
            .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}

struct OnDeviceMuseModel {
    enum Intent { case metaphor, simile, personification, hyperbole, oxymoron, rhyme, sensory }
    enum Theme { case love, nature, darkness, sea, time, war, religion, generic }
    
    func generateSuggestion(for verses: [String], intent: Intent) async -> String {
        try? await Task.sleep(nanoseconds: 600_000_000)
        let meaningfulVerses = verses.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        let fullContext = meaningfulVerses.joined(separator: " ").lowercased()
        let lastVerse = meaningfulVerses.last ?? ""
        let theme = detectTheme(from: fullContext)
        
        switch intent {
        case .metaphor: return templateForMetaphor(theme: theme)
        case .simile: return templateForSimile(theme: theme)
        case .personification: return templateForPersonification(theme: theme)
        case .hyperbole: return templateForHyperbole(theme: theme)
        case .oxymoron: return templateForOxymoron(theme: theme)
        case .sensory: return templateForSensory(theme: theme)
        case .rhyme: return suggestRhymes(for: lastVerse)
        }
    }
    
    private func detectTheme(from context: String) -> Theme {
        if context.contains("amor") || context.contains("cuor") || context.contains("baci") || context.contains("anima") || context.contains("passione") { return .love }
        if context.contains("guerra") || context.contains("spad") || context.contains("sangue") || context.contains("battaglia") || context.contains("scud") { return .war }
        if context.contains("dio") || context.contains("ciel") || context.contains("preg") || context.contains("spirito") || context.contains("sacr") { return .religion }
        if context.contains("mar") || context.contains("acqu") || context.contains("ond") || context.contains("spiaggi") || context.contains("nav") { return .sea }
        if context.contains("nott") || context.contains("bui") || context.contains("ombr") || context.contains("mort") || context.contains("mistero") { return .darkness }
        if context.contains("temp") || context.contains("or") || context.contains("vit") || context.contains("giorn") || context.contains("eterno") { return .time }
        if context.contains("alber") || context.contains("fior") || context.contains("vent") || context.contains("fogli") || context.contains("mont") || context.contains("sole") { return .nature }
        return .generic
    }
    
    private func templateForMetaphor(theme: Theme) -> String {
        let options: [Theme: [String]] = [
            .love: ["[Soggetto] è un fuoco di [emozione]", "Il mio cuore è un [luogo] in rovina", "L'amore è un [sostantivo] senza fine"],
            .nature: ["[Soggetto] è una foresta di [emozione]", "Il cielo è un [oggetto] d'argento", "La terra è un [sostantivo] addormentato"],
            .darkness: ["[Soggetto] è un abisso di [emozione]", "La notte è un [sostantivo] di velluto", "L'ombra è un [animale] in agguato"],
            .sea: ["[Soggetto] è un oceano di [emozione]", "L'onda è un [sostantivo] furioso", "Il mare è un [luogo] di ricordi"],
            .time: ["Il tempo è un ladro di [sostantivo]", "I giorni sono [sostantivo plurale] al vento", "[Soggetto] è un orologio senza lancette"],
            .war: ["La battaglia è una tempesta di [sostantivo]", "La spada è un fulmine di [emozione]", "[Soggetto] è un campo di cenere"],
            .religion: ["La fede è un faro di [sostantivo]", "[Soggetto] è un tempio di silenzio", "L'anima è un [sostantivo] immortale"],
            .generic: ["[Soggetto] è un labirinto di [emozione]", "La vita è un [sostantivo] inatteso", "[Soggetto] è un riflesso di [astratto]"]
        ]
        return options[theme]?.randomElement() ?? "[Soggetto] è un [sostantivo] di [emozione]"
    }
    
    private func templateForSimile(theme: Theme) -> String {
        let options: [Theme: [String]] = [
            .love: ["Come un sospiro che [azione verbale]", "Simile a un bacio che [azione verbale]", "Come una fiamma che [azione verbale]"],
            .nature: ["Come una foglia che [azione verbale]", "Simile a un albero che [azione verbale]", "Come il vento che [azione verbale]"],
            .darkness: ["Come un'ombra che [azione verbale]", "Simile a un fantasma che [azione verbale]", "Come la notte che [azione verbale]"],
            .sea: ["Come un'onda che [azione verbale]", "Simile a una barca che [azione verbale]", "Come la marea che [azione verbale]"],
            .time: ["Come sabbia che [azione verbale]", "Simile alle ore che [azione verbale]"],
            .war: ["Come uno scudo che [azione verbale]", "Simile a un guerriero che [azione verbale]"],
            .religion: ["Come una preghiera che [azione verbale]", "Simile a un santo che [azione verbale]"],
            .generic: ["Come [elemento] che [azione verbale]", "Simile a [soggetto] che [azione verbale]"]
        ]
        return options[theme]?.randomElement() ?? "Come [soggetto] che [azione verbale]"
    }
    
    private func templateForPersonification(theme: Theme) -> String {
        return [
            "[Elemento inanimato] sussurra [un segreto/parole]",
            "[Elemento naturale] piange [sostantivo plurale]",
            "[Concetto astratto] cammina al mio fianco",
            "[Oggetto inanimato] mi guarda con occhi di [aggettivo]"
        ].randomElement()!
    }
    
    private func templateForHyperbole(theme: Theme) -> String {
        return [
            "Un [sostantivo] grande come l'universo",
            "Ho pianto [numero esagerato] di lacrime per te",
            "Un [emozione] che potrebbe spezzare le montagne",
            "Un grido che fa tremare le stelle"
        ].randomElement()!
    }
    
    private func templateForOxymoron(theme: Theme) -> String {
        return [
            "Un [sostantivo positivo] [aggettivo negativo]",
            "Ascolto il [suono rumoroso] del silenzio",
            "Una [sensazione fredda] che brucia",
            "Una [emozione dolorosa] dolcissima"
        ].randomElement()!
    }
    
    private func templateForSensory(theme: Theme) -> String {
        return [
            "Sento il [suono/profumo] di [sostantivo]",
            "Guardo il [colore/luce] di [sostantivo]",
            "Tocco la [consistenza] di [sostantivo astratto]"
        ].randomElement()!
    }
    
    private func suggestRhymes(for verse: String) -> String {
        guard verse.count >= 3 else { return "... [parola in rima]" }
        let suffix = String(verse.trimmingCharacters(in: .punctuationCharacters).suffix(3)).lowercased()
        switch suffix {
        case "ore": return "... [cuore / dolore / amore / ardore / fiore]"
        case "ita": return "... [smarrita / vita / ferita / infinita / gradita]"
        case "ato": return "... [fato / prato / fiato / spietato / amato]"
        case "ale": return "... [mortale / fatale / strale / ideale / reale]"
        case "ela": return "... [stella / bella / procella / favella]"
        case "are": return "... [mare / volare / sognare / cantare / amare]"
        case "nto": return "... [vento / tormento / pianto / spento / lento]"
        case "ura": return "... [paura / natura / oscurità / sventura / pura]"
        case "ino": return "... [destino / cammino / divino / mattino / bambino]"
        case "eza", "ezza": return "... [bellezza / tristezza / carezza / dolcezza]"
        case "gio", "ggio": return "... [coraggio / viaggio / raggio / miraggio]"
        case "nte", "ente": return "... [mente / niente / presente / lucente / furente]"
        case "nza", "anza": return "... [speranza / distanza / danza / rimembranza]"
        default: return "... [parola che fa rima con '\(suffix)']"
        }
    }
}
