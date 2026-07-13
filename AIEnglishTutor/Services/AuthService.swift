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
    case loginFailed
    case tokenRefreshFailed
}

@MainActor
final class StubAuthService: AuthService {
    private var session: AuthSession?

    func currentSession() async throws -> AuthSession? { session }

    func signIn() async throws -> AuthSession {
        let newSession = AuthSession(
            accessToken: "stub-access-token",
            refreshToken: "stub-refresh-token",
            expiresAt: Date().addingTimeInterval(3600),
            accountID: "local-test-account"
        )
        session = newSession
        return newSession
    }

    func signOut() async throws { session = nil }
}
