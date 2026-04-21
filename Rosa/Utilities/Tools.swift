import SwiftUI

/// Global helper functions for VoiceOver and Accessibility.
extension View {
    
    /// Posts a global VoiceOver announcement. Useful for game events or timers.
    /// - Parameter message: The text to be spoken by VoiceOver.
    func postAnnouncement(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }
    
    /// Standardizes accessibility for a poem library card.
    func accessiblePoemCard(title: String, author: String, category: String) -> some View {
        self
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Poem: \(title), by \(author)")
            .accessibilityValue("Category: \(category)")
            .accessibilityHint("Double tap to read and analyze this poem.")
            .accessibilityAddTraits(.isButton)
    }
    
    /// Standardizes accessibility for a game tap target (e.g., Rhyme Hunter).
    func accessibleGameTarget(label: String, hint: String, isCorrect: Bool? = nil) -> some View {
        self
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(label)
            .accessibilityHint(hint)
            .accessibilityValue(isCorrect == true ? "Correct" : (isCorrect == false ? "Incorrect" : ""))
            .accessibilityAddTraits(.isButton)
    }
}