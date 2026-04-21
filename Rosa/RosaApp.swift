//
//  RosaApp.swift
//  Rosa
//
//  Created by Antonio Navarra on 14/03/26.
//

import SwiftUI

@main
struct RosaApp: App {
    // Initialize the single source of truth for the app
    @StateObject private var appEnvironment = AppEnvironment()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                // Inject the environment into the view hierarchy
                .environmentObject(appEnvironment)
        }
    }
}
