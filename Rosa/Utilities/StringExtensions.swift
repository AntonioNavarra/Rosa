//
//  StringExtensions.swift
//  Dante
//
//  Created by Antonio Navarra on 23/02/26.
//


import Foundation

extension String {
    
    /// Splits a large block of text into individual verse strings, removing empty lines.
    /// - Returns: An array of verses.
    func splitIntoVerses() -> [String] {
        return self.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
    
    /// Extracts the approximate last syllable/ending of a word for rhyme detection.
    /// - Returns: The last 3 characters (basic approximation for Phase 1).
    func lastSyllable() -> String {
        let cleaned = self.trimmingCharacters(in: .punctuationCharacters).lowercased()
        guard cleaned.count >= 3 else { return cleaned }
        return String(cleaned.suffix(3))
    }
    
    /// Determines if this string rhymes with another string based on their endings.
    /// - Parameter other: The string to compare against.
    /// - Returns: True if they share the same phonetic ending.
    func identifiesRhyme(with other: String) -> Bool {
        return self.lastSyllable() == other.lastSyllable()
    }
    
    /// Estimates the number of syllables in an Italian verse.
    /// This Phase 1 algorithm counts vowel groups (handling basic diphthongs/elisions).
    /// - Returns: The estimated syllable count.
    func countSyllables() -> Int {
        let lowercased = self.lowercased()
        let vowels: Set<Character> = ["a", "e", "i", "o", "u", "à", "è", "é", "ì", "ò", "ù"]
        
        var syllableCount = 0
        var isCurrentlyInVowelGroup = false
        
        for character in lowercased {
            if vowels.contains(character) {
                // If we hit a vowel and we aren't already tracking a vowel group,
                // it counts as a new syllable. This handles basic Italian diphthongs.
                if !isCurrentlyInVowelGroup {
                    syllableCount += 1
                    isCurrentlyInVowelGroup = true
                }
            } else if character.isLetter {
                // Hitting a consonant breaks the vowel group
                isCurrentlyInVowelGroup = false
            } else {
                // Punctuation (like apostrophes for elision l'amore) breaks the group
                isCurrentlyInVowelGroup = false
            }
        }
        
        return syllableCount
    }
}
