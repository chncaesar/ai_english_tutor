import Foundation

struct PracticePoint: Equatable, Codable, Identifiable {
    let id: UUID
    var text: String
    var reason: String

    init(id: UUID = UUID(), text: String, reason: String) {
        self.id = id
        self.text = text
        self.reason = reason
    }
}

struct PracticeSelection: Equatable, Codable {
    var extractedVocabulary: [String]
    var extractedSentencePatterns: [String]
    var points: [PracticePoint]
    var openingGreeting: String
}
