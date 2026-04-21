//
//  AppEnvironment.swift
//  Dante
//
//  Created by Antonio Navarra on 27/02/26.
//


import SwiftUI
import Combine

/// The single source of truth for global app state.
/// We use ObservableObject to seamlessly integrate with the existing MyApp structure.
class AppEnvironment: ObservableObject {
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: "hasSeenOnboarding")
        }
    }
    
    init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    }
}
