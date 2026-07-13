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
    @Published var practiceStartedAt: Date?

    private let markdownStore: MarkdownStore
    private let practiceSelectionStore: PracticeSelectionStore
    private let practiceRecordStore: PracticeRecordStore
    private let authService: AuthService
    private let preparationService: PracticePreparationService
    private let realtimeVoiceService: RealtimeVoiceService
    private let practiceRecordService = PracticeRecordService()
    private let maxPracticeDuration: TimeInterval = 20 * 60

    init(
        isLoggedIn: Bool = false,
        markdownStore: MarkdownStore = MarkdownStore(),
        practiceSelectionStore: PracticeSelectionStore = PracticeSelectionStore(),
        practiceRecordStore: PracticeRecordStore = PracticeRecordStore(),
        authService: AuthService = StubAuthService(),
        preparationService: PracticePreparationService = PracticePreparationService(client: LocalPracticePreparationClient()),
        realtimeVoiceService: RealtimeVoiceService = StubRealtimeVoiceService()
    ) {
        self.isLoggedIn = isLoggedIn
        self.route = isLoggedIn ? .mainVoiceChat : .firstUseLogin
        self.markdownStore = markdownStore
        self.practiceSelectionStore = practiceSelectionStore
        self.practiceRecordStore = practiceRecordStore
        self.authService = authService
        self.preparationService = preparationService
        self.realtimeVoiceService = realtimeVoiceService
        self.markdownDocument = try? markdownStore.load()
        self.practiceSelection = try? practiceSelectionStore.load()
        self.latestPracticeRecord = try? practiceRecordStore.load()
    }

    func signInWithChatGPT() async {
        do {
            _ = try await authService.signIn()
            isLoggedIn = true
            route = .mainVoiceChat
        } catch AuthServiceError.unsupportedByChatGPTPlusProOAuth {
            voiceState = .error("当前版本尚未完成 ChatGPT Plus/Pro 登录验证，请等待后续版本。")
        } catch {
            voiceState = .error("无法完成 ChatGPT 登录，请稍后重试。")
        }
    }

    func markLoggedOut() async {
        try? await authService.signOut()
        isLoggedIn = false
        route = .firstUseLogin
        voiceState = .notConnected
        practiceStartedAt = nil
    }

    func saveMarkdown(title: String, body: String) {
        do {
            markdownDocument = try markdownStore.save(title: title, body: body)
            practiceSelection = nil
            latestPracticeRecord = nil
            try? practiceSelectionStore.delete()
            try? practiceRecordStore.delete()
        } catch {
            voiceState = .error("无法保存 Markdown，请重试。")
        }
    }

    func deleteMarkdown() {
        do {
            try markdownStore.delete()
            markdownDocument = nil
            practiceSelection = nil
            latestPracticeRecord = nil
            try? practiceSelectionStore.delete()
            try? practiceRecordStore.delete()
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
            let selection = try await preparationService.prepare(from: markdownDocument)
            practiceSelection = selection
            try practiceSelectionStore.save(selection)
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
            guard practiceStartedAt == nil || !isPracticeTimeLimitReached else {
                voiceState = .error("本次练习已达到 20 分钟，请结束后生成练习记录。")
                return
            }
            try await realtimeVoiceService.start(selection: practiceSelection, markdown: markdownDocument)
            practiceStartedAt = Date()
            voiceState = .listening
        } catch RealtimeVoiceError.unsupportedByChatGPTPlusProOAuth {
            voiceState = .error("ChatGPT 登录暂不支持实时语音，请停止本版实现并反馈。")
        } catch {
            voiceState = .error("语音连接失败，请重新开始。")
        }
    }

    func finishVoicePractice() async {
        await realtimeVoiceService.stop()
        generatePracticeRecord()
        practiceStartedAt = nil
        voiceState = .notConnected
    }

    var isPracticeTimeLimitReached: Bool {
        guard let practiceStartedAt else { return false }

        return Date().timeIntervalSince(practiceStartedAt) >= maxPracticeDuration
    }

    func generatePracticeRecord() {
        guard let markdownDocument, let practiceSelection else {
            voiceState = .error("当前还没有可保存的练习记录。")
            return
        }

        let record = practiceRecordService.generate(
            markdown: markdownDocument,
            selection: practiceSelection,
            logs: voiceLogs
        )
        do {
            try practiceRecordStore.save(record)
            latestPracticeRecord = record
        } catch {
            voiceState = .error("无法保存练习记录，请稍后重试。")
        }
    }
}
