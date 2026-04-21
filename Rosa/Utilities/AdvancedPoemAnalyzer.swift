import Foundation
import NaturalLanguage

/// An advanced engine that uses Apple's Natural Language framework to analyze Italian poetry.
class AdvancedPoemAnalyzer {
    
    // MARK: - Public Analysis Methods
    
    /// Classifies the meter based on the average syllable count.
    func classifyMeter(syllableCounts: [Int]) -> String {
        guard !syllableCounts.isEmpty else { return "Unknown" }
        let average = syllableCounts.reduce(0, +) / syllableCounts.count
        
        switch average {
        case 7: return "Settenario (7 Syllables)"
        case 8: return "Ottonario (8 Syllables)"
        case 11: return "Endecasillabo (11 Syllables)"
        default: return "Verso Libero (Free Verse)"
        }
    }
    
    /// Analyzes the rhyme scheme by comparing the last phonetic sounds of each verse.
    func analyzeRhymeScheme(poem: Poem) -> String {
        var schemeMap: [String: Character] = [:]
        var currentLetter: Character = "A"
        var schemeResult = ""
        
        for verse in poem.verses {
            let ending = getPhoneticEnding(for: verse)
            if ending.isEmpty { continue }
            
            if let assignedLetter = schemeMap[ending] {
                schemeResult.append(assignedLetter)
            } else {
                schemeMap[ending] = currentLetter
                schemeResult.append(currentLetter)
                
                // Increment to the next letter in the alphabet (A -> B -> C)
                if let asciiValue = currentLetter.asciiValue {
                    currentLetter = Character(UnicodeScalar(asciiValue + 1))
                }
            }
        }
        
        return schemeResult.isEmpty ? poem.rhymeScheme : schemeResult
    }
    
    /// Evaluates if two Italian verses rhyme phonetically.
    func doVersesRhyme(_ verseA: String, _ verseB: String) -> Bool {
        let endingA = getPhoneticEnding(for: verseA)
        let endingB = getPhoneticEnding(for: verseB)
        
        return !endingA.isEmpty && endingA == endingB
    }
    
    /// Calculates the syllable count for each verse using Natural Language tokenization.
    func analyzeMeter(verses: [String]) -> [Int] {
        return verses.map { countItalianSyllables(in: $0) }
    }
    
    // MARK: - Private Phonetic & Syllable Engine
    
    /// Extracts the final phonetic block of a verse for accurate Italian rhyme detection.
    private func getPhoneticEnding(for verse: String) -> String {
        let cleaned = verse.trimmingCharacters(in: .punctuationCharacters).lowercased()
        let words = cleaned.components(separatedBy: .whitespaces)
        guard let lastWord = words.last, !lastWord.isEmpty else { return "" }
        
        let vowels: Set<Character> = ["a", "e", "i", "o", "u", "à", "è", "é", "ì", "ò", "ù"]
        let chars = Array(lastWord)
        
        // Find the index of the last vowel. In typical Italian words, the rhyme
        // relies heavily on the final vowel and proceeding consonants (e.g., am-ORE).
        var lastVowelIndex = -1
        for i in stride(from: chars.count - 1, through: 0, by: -1) {
            if vowels.contains(chars[i]) {
                lastVowelIndex = i
                break
            }
        }
        
        // If a vowel is found, we extract from the character just before it (if possible)
        // to capture the consonance context (e.g., 'ore' from 'cuore').
        if lastVowelIndex >= 0 {
            let startIndex = max(0, lastVowelIndex - 1)
            return String(chars[startIndex...])
        }
        
        return String(lastWord.suffix(3)) // Fallback
    }
    
    /// Counts syllables in an Italian verse using NLTokenizer and phonetic rules.
    private func countItalianSyllables(in verse: String) -> Int {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = verse
        tokenizer.setLanguage(.italian)
        
        var totalSyllables = 0
        var previousWordEndsWithVowel = false
        let vowels: Set<Character> = ["a", "e", "i", "o", "u", "à", "è", "é", "ì", "ò", "ù"]
        
        tokenizer.enumerateTokens(in: verse.startIndex..<verse.endIndex) { tokenRange, _ in
            let word = String(verse[tokenRange]).lowercased()
            var wordSyllables = 0
            var inVowelGroup = false
            
            for char in word {
                if vowels.contains(char) {
                    if !inVowelGroup {
                        wordSyllables += 1
                        inVowelGroup = true
                    }
                } else {
                    inVowelGroup = false
                }
            }
            
            // Handle Synalepha (vowel elision across words)
            if previousWordEndsWithVowel, let firstChar = word.first, vowels.contains(firstChar) {
                wordSyllables = max(0, wordSyllables - 1)
            }
            
            totalSyllables += wordSyllables
            previousWordEndsWithVowel = vowels.contains(word.last ?? " ")
            return true
        }
        
        return totalSyllables
    }
}
