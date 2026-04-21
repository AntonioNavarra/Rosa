//
//  RhetoricalFigure.swift
//  Dante
//
//  Created by Antonio Navarra on 27/02/26.
//


import Foundation

/// Represents a rhetorical or poetic figure found in Italian poetry.
enum RhetoricalFigure: String, Codable, CaseIterable {
    case metaphor        = "Metaphor"
    case simile          = "Simile"
    case personification = "Personification"
    case anaphora        = "Anaphora"
    case hyperbole       = "Hyperbole"
    case oxymoron        = "Oxymoron"
    case alliteration    = "Alliteration"
    
    /// A short definition shown to the user after answering.
    var definition: String {
        switch self {
        case .metaphor:        return "A direct comparison between two unlike things without using 'like' or 'as'."
        case .simile:          return "A comparison using 'like' or 'as' (come, quanto)."
        case .personification: return "Giving human qualities to non-human things."
        case .anaphora:        return "Repetition of the same word or phrase at the beginning of successive verses."
        case .hyperbole:       return "An extreme exaggeration used for emphasis."
        case .oxymoron:        return "Two contradictory terms placed side by side."
        case .alliteration:    return "Repetition of the same consonant sound at the start of nearby words."
        }
    }
    
    /// Italian name for display in the UI.
    var italianName: String {
        switch self {
        case .metaphor:        return "Metafora"
        case .simile:          return "Similitudine"
        case .personification: return "Personificazione"
        case .anaphora:        return "Anafora"
        case .hyperbole:       return "Iperbole"
        case .oxymoron:        return "Ossimoro"
        case .alliteration:    return "Allitterazione"
        }
    }
}