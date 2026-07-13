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
    @Published var practiceSelection: PracticeSelection?

    private let markdownStore: MarkdownStore
    private let preparationService: PracticePreparationService

    init(
        isLoggedIn: Bool = false,
        markdownStore: MarkdownStore = MarkdownStore(),
        preparationService: PracticePreparationService = PracticePreparationService(client: LocalPracticePreparationClient())
    ) {
        self.isLoggedIn = isLoggedIn
        self.route = isLoggedIn ? .mainVoiceChat : .firstUseLogin
        self.markdownStore = markdownStore
        self.preparationService = preparationService
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
            practiceSelection = nil
        } catch {
            voiceState = .error("无法保存 Markdown，请重试。")
        }
    }

    func deleteMarkdown() {
        do {
            try markdownStore.delete()
            markdownDocument = nil
            practiceSelection = nil
        } catch {
            voiceState = .error("无法删除 Markdown，请重试。")
        }
    }

    func preparePractice() async {
        guard let markdownDocument else {
            voiceState = .error("当前还没有 Markdown 内容，请先上传。")
            return
        }

        do {
            practiceSelection = try await preparationService.prepare(from: markdownDocument)
        } catch {
            voiceState = .error("无法准备本次练习内容，请稍后重试。")
        }
    }
}
