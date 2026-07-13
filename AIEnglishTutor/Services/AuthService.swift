import Foundation

struct AuthSession: Equatable, Codable {
    var accessToken: String
    var refreshToken: String
    var expiresAt: Date
    var accountID: String
}

@MainActor
protocol AuthService {
    func currentSession() async throws -> AuthSession?
    func signIn() async throws -> AuthSession
    func signOut() async throws
}

enum AuthServiceError: Error, Equatable {
    case unsupportedByChatGPTPlusProOAuth
    case loginFailed
    case tokenRefreshFailed
}

@MainActor
final class StubAuthService: AuthService {
    func currentSession() async throws -> AuthSession? { nil }

    func signIn() async throws -> AuthSession {
        throw AuthServiceError.unsupportedByChatGPTPlusProOAuth
    }

    func signOut() async throws {}
}
