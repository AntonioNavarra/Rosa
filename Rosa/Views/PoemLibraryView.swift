import SwiftUI

/// The main dashboard featuring a sophisticated vertical anthology list.
struct PoemLibraryView: View {
    let poems: [Poem]
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                
                // Classic Header
                VStack(spacing: 12) {
                    Text("❧")
                        .font(.system(size: 30, design: .serif))
                        .foregroundColor(Color(red: 0.4, green: 0.1, blue: 0.1))
                    
                    Text("Anthology")
                        .font(.system(size: 40, weight: .heavy, design: .serif))
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                        .tracking(1.5)
                    
                    Text("A curated collection of Italian literary masterpieces.")
                        .font(.system(.subheadline, design: .serif))
                        .italic()
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .multilineTextAlignment(.center)
                    
                    Divider().frame(width: 100).padding(.top, 4)
                }
                .padding(.top, 24)
                
                // Vertical List of Works
                LazyVStack(spacing: 20) {
                    ForEach(poems) { poem in
                        NavigationLink(destination: PoemDetailView(poem: poem)) {
                            AnthologyRowCard(poem: poem)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .background(parchmentColor.ignoresSafeArea())
    }
}

/// A horizontal card representing a single work in the vertical list.
struct AnthologyRowCard: View {
    let poem: Poem
    
    var body: some View {
        HStack(spacing: 16) {
            // Smart Cover on the left
            SmartCoverView(poem: poem, width: 80, height: 120)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 2, y: 2)
            
            // Text Details on the right
            VStack(alignment: .leading, spacing: 8) {
                Text(poem.title)
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                    .lineLimit(2)
                
                Text(poem.author)
                    .font(.system(.subheadline, design: .serif))
                    .italic()
                    .foregroundColor(Color(red: 0.4, green: 0.1, blue: 0.1))
                
                Spacer()
                
                HStack {
                    Text(poem.era.uppercased())
                        .font(.system(size: 10, design: .serif))
                        .fontWeight(.bold)
                        .tracking(1.5)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(poem.category.displayName)
                        .font(.system(size: 10, design: .serif))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.primary.opacity(0.05))
                        .cornerRadius(4)
                }
            }
            .padding(.vertical, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary.opacity(0.5))
        }
        .padding(12)
        .background(Color(UIColor.systemBackground).opacity(0.6))
        .overlay(Rectangle().stroke(Color.primary.opacity(0.1), lineWidth: 1))
        .cornerRadius(8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Poem: \(poem.title) by \(poem.author)")
    }
}

/// A "Smart" view that generates a beautiful, minimalist leather cover.
struct SmartCoverView: View {
    let poem: Poem
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            // Beautiful fallback generated cover
            Color(red: 0.25, green: 0.10, blue: 0.10) // Cordovan leather
            
            // Minimalist, elegant author initial
            Text(String(poem.author.prefix(1)))
                .font(.system(size: width * 0.5, weight: .heavy, design: .serif))
                .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.4).opacity(0.8)) // Gold text
            
            // Gold tooling borders
            RoundedRectangle(cornerRadius: 2)
                .stroke(Color(red: 0.85, green: 0.75, blue: 0.4).opacity(0.7), lineWidth: 1)
                .padding(4)
            
            // If the user adds a real image to the project resources, it overlays the fallback!
            if let imageName = poem.coverImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(4)
        .clipped()
    }
}
