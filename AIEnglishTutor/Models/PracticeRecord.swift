import Foundation

struct PracticeRecord: Equatable, Codable, Identifiable {
    let id: UUID
    var markdown: String
    var createdAt: Date

    init(id: UUID = UUID(), markdown: String, createdAt: Date = Date()) {
        self.id = id
        self.markdown = markdown
        self.createdAt = createdAt
    }
}
