import Foundation

/// The core data model representing a single poem or a famous excerpt.
struct Poem: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let author: String
    let era: String
    let verses: [String]
    let stanzas: [[Int]]
    let rhymeScheme: String
    
    // NEW: Core educational fields
    private let rawParaphrases: [String: String]?
    private let rawFigures: [String: String]?
    let poeticStyle: String
    
    let category: PoemCategory
    let themes: [String]
    let metrics: PoemMetrics?
    let coverImageName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, author, era, verses, stanzas, rhymeScheme, category, themes, metrics, coverImageName, poeticStyle
        case rawParaphrases = "paraphrases"
        case rawFigures = "figures"
    }
    
    /// Maps verse index to its modern prose paraphrase/translation.
    var paraphrases: [Int: String] {
        var parsedDict = [Int: String]()
        for (key, value) in rawParaphrases ?? [:] {
            if let intKey = Int(key) {
                parsedDict[intKey] = value
            }
        }
        return parsedDict
    }
    
    /// Maps verse index to the rhetorical figure it contains.
    var figures: [Int: RhetoricalFigure] {
        var parsedDict = [Int: RhetoricalFigure]()
        for (key, value) in rawFigures ?? [:] {
            if let intKey = Int(key), let figure = RhetoricalFigure(rawValue: value) {
                parsedDict[intKey] = figure
            }
        }
        return parsedDict
    }
}
