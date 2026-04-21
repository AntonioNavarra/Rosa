import SwiftUI

/// The main detail screen for reading and analyzing a poem.
struct PoemDetailView: View {
    let poem: Poem
    @State private var selectedMode: ViewMode = .read
    
    enum ViewMode: String, CaseIterable, Identifiable {
        case read = "Read"
        case analyze = "Analyze"
        var id: Self { self }
    }
    
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    
    var body: some View {
        ZStack {
            parchmentColor.ignoresSafeArea()
            GenerativeBackground(era: poem.era)
            
            VStack(spacing: 0) {
                Picker("Mode", selection: $selectedMode) {
                    ForEach(ViewMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                .background(parchmentColor.opacity(0.9))
                
                Divider()
                
                if selectedMode == .read {
                    ReadModeView(poem: poem)
                } else {
                    MetricsView(poem: poem)
                        .padding()
                }
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Dedicated to reading the poem with line-by-line Paraphrases and Poetic Style analysis.
struct ReadModeView: View {
    let poem: Poem
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                
                SmartCoverView(poem: poem, width: 120, height: 180)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    .padding(.top, 16)
                
                VStack(alignment: .center, spacing: 12) {
                    Text(poem.title)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .multilineTextAlignment(.center)
                    
                    Text("by " + poem.author)
                        .font(.system(.title3, design: .serif))
                        .italic()
                        .foregroundColor(cordovanColor)
                    
                    Divider().frame(width: 60).padding(.top, 8)
                }
                .frame(maxWidth: .infinity)
                
                // Verses with Paraphrase disclosures
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(poem.verses.enumerated()), id: \.offset) { index, verse in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(verse)
                                .font(.system(.title3, design: .serif))
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                                .lineSpacing(6)
                            
                            // Paraphrase is shown directly under the relevant verse
                            if let paraphrase = poem.paraphrases[index] {
                                DisclosureGroup("Paraphrase") {
                                    Text(paraphrase)
                                        .font(.subheadline)
                                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                                        .padding(.top, 4)
                                }
                                .font(.system(.caption, design: .serif, weight: .semibold))
                                .foregroundColor(cordovanColor)
                                .tint(cordovanColor)
                                .padding(.leading, 12)
                                .padding(.vertical, 4)
                            }
                        }
                        .padding(.bottom, 4)
                    }
                }
                .padding(.horizontal, 24)
                
                // Author's Poetic Style Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "quill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.4))
                        Text("Author's Poetic Style")
                            .font(.system(.title2, design: .serif))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    }
                    
                    Text(poem.poeticStyle)
                        .font(.system(.body, design: .serif))
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .lineSpacing(6)
                }
                .padding(24)
                .background(Color.white.opacity(0.5))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.primary.opacity(0.1), lineWidth: 1))
                .padding(.horizontal, 24)
                .padding(.top, 16)
            }
            .padding(.bottom, 40)
        }
    }
}
