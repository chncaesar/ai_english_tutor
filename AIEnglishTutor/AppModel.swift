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
    @Published var voiceLogs: [VoiceSessionLog] = []
    @Published var latestPracticeRecord: PracticeRecord?

    private let markdownStore: MarkdownStore
    private let preparationService: PracticePreparationService
    private let realtimeVoiceService: RealtimeVoiceService
    private let practiceRecordService = PracticeRecordService()

    init(
        isLoggedIn: Bool = false,
        markdownStore: MarkdownStore = MarkdownStore(),
        preparationService: PracticePreparationService = PracticePreparationService(client: LocalPracticePreparationClient()),
        realtimeVoiceService: RealtimeVoiceService = StubRealtimeVoiceService()
    ) {
        self.isLoggedIn = isLoggedIn
        self.route = isLoggedIn ? .mainVoiceChat : .firstUseLogin
        self.markdownStore = markdownStore
        self.preparationService = preparationService
        self.realtimeVoiceService = realtimeVoiceService
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

    func startVoicePractice() async {
        guard let markdownDocument else {
            voiceState = .error("当前还没有 Markdown 内容，请先上传。")
            return
        }
        guard let practiceSelection else {
            voiceState = .error("当前还没有练习内容，请先准备本次练习。")
            return
        }

        voiceState = .connecting
        do {
            try await realtimeVoiceService.start(selection: practiceSelection, markdown: markdownDocument)
            voiceState = .listening
        } catch RealtimeVoiceError.unsupportedByChatGPTPlusProOAuth {
            voiceState = .error("ChatGPT 登录暂不支持实时语音，请停止本版实现并反馈。")
        } catch {
            voiceState = .error("语音连接失败，请重新开始。")
        }
    }

    func generatePracticeRecord() {
        guard let markdownDocument, let practiceSelection else { return }
        latestPracticeRecord = practiceRecordService.generate(
            markdown: markdownDocument,
            selection: practiceSelection,
            logs: voiceLogs
        )
    }
}
