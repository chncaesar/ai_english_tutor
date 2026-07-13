import Foundation

struct VoiceSessionLog: Equatable, Codable, Identifiable {
    enum Role: String, Codable {
        case user
        case tutor
        case system
    }

    let id: UUID
    var role: Role
    var text: String
    var timestamp: Date

    init(id: UUID = UUID(), role: Role, text: String, timestamp: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.timestamp = timestamp
    }
}
