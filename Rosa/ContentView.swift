import SwiftUI

/// The root view of the application that manages data loading, error handling,
/// and displaying the main anthology dashboard.
struct ContentView: View {
    @EnvironmentObject private var appEnvironment: AppEnvironment
    
    @State private var poems: [Poem] = []
    @State private var errorMessage: String?
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    VStack(spacing: 20) {
                        ProgressView().scaleEffect(1.5)
                        Text("Loading Anthology...").font(.headline).foregroundColor(.secondary)
                    }
                } else if let errorMessage = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 40)).foregroundColor(.red)
                        Text("Failed to load poetry").font(.headline)
                        Text(errorMessage).font(.subheadline).foregroundColor(.secondary).multilineTextAlignment(.center).padding(.horizontal)
                    }
                } else {
                    TabView {
                        // Tab 1: Anthology (Changed from Library)
                        PoemLibraryView(poems: poems)
                            .tabItem {
                                Label("Anthology", systemImage: "books.vertical.fill")
                            }
                        
                        // Tab 2: Mini-Games
                        GamesMenuView(poems: poems)
                            .tabItem {
                                Label("Games", systemImage: "gamecontroller.fill")
                            }
                            
                        // Tab 3: Creator Mode
                        PoetryEditorView()
                            .tabItem {
                                Label("Studio", systemImage: "quill")
                            }
                    }
                    .tint(Color(red: 0.4, green: 0.1, blue: 0.1)) // Classic red tint for tabs
                }
            }
            .task {
                await loadPoetryData()
            }
            .fullScreenCover(isPresented: Binding(
                get: { !appEnvironment.hasSeenOnboarding },
                set: { _ in }
            )) {
                OnboardingView()
                    .environmentObject(appEnvironment)
            }
        }
    }
    
    @MainActor
    private func loadPoetryData() async {
        let result = await PoemDataLoader.shared.loadPoems()
        switch result {
        case .success(let loadedPoems):
            self.poems = loadedPoems
            self.isLoading = false
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
