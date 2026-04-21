import SwiftUI

/// The grand entryway to the unified arcade mode, now featuring the legendary "Rose's Challenge".
struct GamesMenuView: View {
    let poems: [Poem]
    
    // Persistent High Score
    @AppStorage("rosesChallengeHighScore") private var highScore: Int = 0
    let rosesRecord: Int = 150
    
    // Antique ivory parchment background
    let parchmentColor = Color(red: 0.95, green: 0.93, blue: 0.88)
    let cordovanColor = Color(red: 0.25, green: 0.10, blue: 0.10)
    let goldColor = Color(red: 0.85, green: 0.75, blue: 0.4)
    
    @State private var isShowingTrial = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                parchmentColor.ignoresSafeArea()
                
                VStack(spacing: 32) {
                    
                    // Classic Header
                    VStack(spacing: 8) {
                        Text("❧")
                            .font(.system(size: 30, design: .serif))
                            .foregroundColor(Color(red: 0.4, green: 0.1, blue: 0.1))
                        
                        Text("Games")
                            .font(.system(size: 40, weight: .heavy, design: .serif))
                            .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.15))
                            .tracking(2)
                        
                        Text("Interactive games and challenges to explore poetry.")
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3))
                        
                        Divider()
                            .frame(width: 100)
                            .padding(.top, 4)
                    }
                    .padding(.top, 40)
                    
                    
                    // The Grand Gateway Card
                    VStack(spacing: 24) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(goldColor)
                        
                        Text("The Rose's Challenge")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.96, green: 0.94, blue: 0.90))
                        
                        Text("Face an endless stream of trials: identify figures, find rhymes, restore verses, fill in the blanks, and discover themes.\n\nYou have 3 lives.")
                            .font(.system(.body, design: .serif))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.white.opacity(0.8))
                            .lineSpacing(6)
                            .padding(.horizontal, 16)
                        
                        // Score Board
                        HStack(spacing: 24) {
                            VStack {
                                Text("YOUR BEST")
                                    .font(.system(size: 10, weight: .bold, design: .serif))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("\(highScore)")
                                    .font(.system(size: 24, weight: .heavy, design: .serif))
                                    .foregroundColor(.white)
                            }
                            
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(width: 1, height: 40)
                            
                            VStack {
                                Text("ROSE's RECORD")
                                    .font(.system(size: 10, weight: .bold, design: .serif))
                                    .foregroundColor(goldColor.opacity(0.8))
                                Text("\(rosesRecord)")
                                    .font(.system(size: 24, weight: .heavy, design: .serif))
                                    .foregroundColor(goldColor)
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Button(action: {
                            isShowingTrial = true
                        }) {
                            Text("Begin the Challenge")
                                .font(.system(.headline, design: .serif))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.96, green: 0.94, blue: 0.90)) // Ivory button
                                .foregroundColor(cordovanColor) // Red text
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                        .padding(.top, 8)
                    }
                    .padding(32)
                    .background(cordovanColor)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(goldColor.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                    .padding(.horizontal, 24)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $isShowingTrial) {
                PoetsTrialView(poems: poems)
            }
        }
    }
}
