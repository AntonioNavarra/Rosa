import SwiftUI

/// Visualizes the structural and rhetorical metrics of a poem.
struct MetricsView: View {
    let poem: Poem
    @State private var animatedVerses: Bool = false
    
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // Summary Card
                VStack(alignment: .leading, spacing: 12) {
                    Text("Structural Analysis")
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(.secondary)
                    
                    HStack {
                        MetricBadge(title: "Meter", value: poem.metrics?.verseType ?? "Unknown", color: .blue)
                        MetricBadge(title: "Scheme", value: poem.rhymeScheme, color: .purple)
                    }
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground).opacity(0.5))
                .cornerRadius(12)
                
                Divider()
                
                // Line-by-line breakdown with Figures
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(Array(poem.verses.enumerated()), id: \.offset) { index, verse in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top) {
                                // Syllable Count Badge
                                let count = poem.metrics?.syllableCounts.indices.contains(index) == true ? poem.metrics!.syllableCounts[index] : 0
                                Text("\(count)")
                                    .font(.system(.caption, design: .serif).bold())
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                                    .background(count == 11 ? Color.green : (count == 7 ? Color.blue : cordovanColor))
                                    .clipShape(Circle())
                                    .padding(.top, 2)
                                
                                Text(verse)
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                            }
                            
                            // NEW: Rhetorical Figure Visualizer
                            if let figure = poem.figures[index] {
                                HStack {
                                    Image(systemName: "sparkles")
                                        .font(.caption2)
                                    Text(figure.italianName)
                                        .font(.system(.caption, design: .serif).bold())
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(8)
                                .padding(.leading, 32) // Indent to align with text
                            }
                        }
                        .opacity(animatedVerses ? 1 : 0)
                        .animation(.easeIn.delay(Double(index) * 0.1), value: animatedVerses)
                    }
                }
            }
        }
        .onAppear {
            animatedVerses = true
        }
    }
}

struct MetricBadge: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(8)
    }
}
