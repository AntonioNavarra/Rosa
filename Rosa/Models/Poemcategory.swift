import Foundation

/// Defines the literary classification of the poem.
/// Conforms to String to easily map to JSON, and Codable for data parsing.
enum PoemCategory: String, Codable, CaseIterable {
    case lyrical = "lyrical"
    case epic = "epic"
    case didactic = "didactic"
    
    /// A user-friendly string for UI display.
    var displayName: String {
        switch self {
        case .lyrical:
            return "Lyrical Poetry"
        case .epic:
            return "Narrative/Epic"
        case .didactic:
            return "Didactic/Satirical"
        }
    }
}
