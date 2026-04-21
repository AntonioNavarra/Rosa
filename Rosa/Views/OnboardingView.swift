import SwiftUI

/// A beautifully styled, multi-page introduction shown on the first launch,
/// designed to look like the opening pages of an antique book.
struct OnboardingView: View {
    @EnvironmentObject private var appEnvironment: AppEnvironment
    @State private var currentPage = 0
    
    // Classic Theme Colors
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    let goldColor = Color(red: 0.85, green: 0.75, blue: 0.4)
    let inkColor = Color(red: 0.15, green: 0.15, blue: 0.15)
    
    init() {
        // Style the pagination dots at the bottom to match our Cordovan leather theme
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(red: 0.25, green: 0.10, blue: 0.10, alpha: 1.0)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(red: 0.25, green: 0.10, blue: 0.10, alpha: 0.2)
    }
    
    var body: some View {
        ZStack {
            // Antique Background
            parchmentColor.ignoresSafeArea()
            
            // Faint generative background to add paper texture without distracting
            GenerativeBackground(era: "Romantic")
                .opacity(0.05)
            
            TabView(selection: $currentPage) {
                // PAGE 1: The Title Page
                VStack(spacing: 24) {
                    Text("❧")
                        .font(.system(size: 40, design: .serif))
                        .foregroundColor(cordovanColor)
                    
                    Text("VERSES")
                        .font(.system(size: 48, weight: .heavy, design: .serif))
                        .foregroundColor(inkColor)
                        .tracking(8) // Wide spacing for a classic print look
                    
                    Divider()
                        .frame(width: 80)
                        .overlay(goldColor.opacity(0.8))
                    
                    Text("An Interactive Anthology\nof Italian Poetry")
                        .font(.system(.title3, design: .serif))
                        .italic()
                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.horizontal, 32)
                }
                .tag(0)
                
                // PAGE 2: The Table of Contents (Features)
                VStack(spacing: 40) {
                    Text("The Curriculum")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundColor(inkColor)
                    
                    VStack(alignment: .leading, spacing: 32) {
                        ClassicFeatureRow(
                            icon: "books.vertical.fill",
                            title: "L'Antologia",
                            description: "Read and analyze curated masterpieces of Italian literature.",
                            iconColor: cordovanColor
                        )
                        
                        ClassicFeatureRow(
                            icon: "",
                            title: "La Bottega",
                            description: "Compose your own verses and master poetic meter.",
                            iconColor: cordovanColor
                        )
                        
                        ClassicFeatureRow(
                            icon: "crown.fill",
                            title: "La Sfida di Rose",
                            description: "Survive an endless trial of literary and phonetic challenges.",
                            iconColor: goldColor
                        )
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer().frame(height: 10)
                    
                    // Enter Button
                    Button(action: {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                        impact.impactOccurred()
                        withAnimation {
                            appEnvironment.hasSeenOnboarding = true
                        }
                    }) {
                        Text("Open the Book")
                            .font(.system(.headline, design: .serif))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(cordovanColor)
                            .foregroundColor(parchmentColor)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(goldColor.opacity(0.6), lineWidth: 1))
                            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    }
                    .padding(.horizontal, 40)
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }
}

/// A highly styled feature row to match the academic aesthetic.
struct ClassicFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let iconColor: Color
    
    let inkColor = Color(red: 0.15, green: 0.15, blue: 0.15)
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(iconColor)
                .frame(width: 40, alignment: .center)
                .padding(.top, 2) // Slight adjustment to align with text
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(.title3, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(inkColor)
                
                Text(description)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                    .lineSpacing(4)
            }
        }
    }
}
