//
//  PoemMetrics.swift
//  Dante
//
//  Created by Antonio Navarra on 23/02/26.
//

import Foundation

/// Holds structural and metrical data for a given poem.
struct PoemMetrics: Codable, Hashable {
    /// The classification of the meter (e.g., "Hendecasyllable")
    let verseType: String
    
    /// The expected number of syllables per verse
    let syllableCounts: [Int]
    
    /// Indicates whether the poem follows a specific rhyme scheme
    let hasRhyme: Bool
}
