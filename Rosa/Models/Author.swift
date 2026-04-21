//
//  Author.swift
//  Dante
//
//  Created by Antonio Navarra on 23/02/26.
//


import Foundation

/// Represents the author of a poem with historical context.
struct Author: Codable, Identifiable, Hashable {
    /// Unique identifier for the author
    let id: UUID
    
    /// Full name of the author
    let name: String
    
    /// A brief 2-3 sentence biography in English
    let biography: String
    
    /// The historical lifespan or active period (e.g., "1265-1321")
    let period: String
    
    /// A list of the author's most famous literary works
    let notableWorks: [String]
}