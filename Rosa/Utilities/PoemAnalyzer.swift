//
//  PoemAnalyzer.swift
//  Dante
//
//  Created by Antonio Navarra on 23/02/26.
//


import Foundation

/// Defines the requirements for an engine capable of analyzing poetic structures.
protocol PoemAnalyzer {
    /// Determines the rhyme scheme (e.g., ABBA) of a given poem.
    func analyzeRhymeScheme(poem: Poem) -> String
    
    /// Calculates the syllable count for an array of verses.
    func analyzeMeter(verses: [String]) -> [Int]
    
    /// Identifies common figures of speech and maps them to verse indices.
    func identifyFiguresOfSpeech(verses: [String]) -> [String: [Int]]
}

/// A Phase 1 implementation of the PoemAnalyzer protocol.
class BasicPoemAnalyzer: PoemAnalyzer {
    
    func analyzeRhymeScheme(poem: Poem) -> String {
        // Phase 1 fallback: return the pre-calculated scheme from the JSON model.
        // Phase 2 will dynamically calculate this using the StringExtensions.
        return poem.rhymeScheme
    }
    
    func analyzeMeter(verses: [String]) -> [Int] {
        // Map over each verse and utilize our String extension to count syllables
        return verses.map { $0.countSyllables() }
    }
    
    func identifyFiguresOfSpeech(verses: [String]) -> [String: [Int]] {
        // Placeholder for Phase 2 Natural Language integration.
        // Currently returns an empty dictionary.
        return [:]
    }
}