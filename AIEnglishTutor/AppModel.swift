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
    @Published var markdownDocument: MarkdownDocument?

    private let markdownStore: MarkdownStore

    init(isLoggedIn: Bool = false, markdownStore: MarkdownStore = MarkdownStore()) {
        self.isLoggedIn = isLoggedIn
        self.route = isLoggedIn ? .mainVoiceChat : .firstUseLogin
        self.markdownStore = markdownStore
        self.markdownDocument = try? markdownStore.load()
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

    func saveMarkdown(title: String, body: String) {
        do {
            markdownDocument = try markdownStore.save(title: title, body: body)
        } catch {
            voiceState = .error("无法保存 Markdown，请重试。")
        }
    }

    func deleteMarkdown() {
        do {
            try markdownStore.delete()
            markdownDocument = nil
        } catch {
            voiceState = .error("无法删除 Markdown，请重试。")
        }
    }
}
