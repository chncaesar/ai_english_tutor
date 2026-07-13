import Foundation
import Combine

enum AppRoute: Equatable {
    case firstUseLogin
    case mainVoiceChat
}

enum AppVoiceState: Equatable {
    case notConnected
    case connecting
    case listening
    case speaking
    case error(String)
}

@MainActor
final class AppModel: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var route: AppRoute
    @Published var voiceState: AppVoiceState = .notConnected

    init(isLoggedIn: Bool = false) {
        self.isLoggedIn = isLoggedIn
        self.route = isLoggedIn ? .mainVoiceChat : .firstUseLogin
    }

    func markLoggedIn() {
        isLoggedIn = true
        route = .mainVoiceChat
    }

    func markLoggedOut() {
        isLoggedIn = false
        route = .firstUseLogin
        voiceState = .notConnected
    }
}
