import XCTest
@testable import AIEnglishTutor

@MainActor
final class RealtimeVoiceServiceTests: XCTestCase {
    func testStartVoicePracticeShowsUnsupportedBlockerWithPreparedSelection() async {
        let model = AppModel(markdownStore: MarkdownStore(directory: temporaryMarkdownDirectory()))
        model.saveMarkdown(title: "Lesson", body: "- Could you help me?\n- delighted\n- I would like coffee.")
        model.practiceSelection = sampleSelection

        await model.startVoicePractice()

        XCTAssertEqual(
            model.voiceState,
            AppVoiceState.error("ChatGPT 登录暂不支持实时语音，请停止本版实现并反馈。")
        )
    }

    func testStartVoicePracticeRequiresPreparedSelection() async {
        let model = AppModel(markdownStore: MarkdownStore(directory: temporaryMarkdownDirectory()))
        model.saveMarkdown(title: "Lesson", body: "- Could you help me?")

        await model.startVoicePractice()

        XCTAssertEqual(model.voiceState, AppVoiceState.error("当前还没有练习内容，请先准备本次练习。"))
    }

    func testFinishVoicePracticeStopsVoiceAndPersistsPracticeRecord() async throws {
        let directory = temporaryMarkdownDirectory()
        let model = AppModel(
            markdownStore: MarkdownStore(directory: directory),
            practiceSelectionStore: PracticeSelectionStore(directory: directory),
            practiceRecordStore: PracticeRecordStore(directory: directory),
            realtimeVoiceService: AllowingRealtimeVoiceService()
        )
        model.saveMarkdown(title: "Lesson", body: "- Could you help me?\n- delighted\n- I would like coffee.")
        model.practiceSelection = sampleSelection

        await model.startVoicePractice()
        await model.finishVoicePractice()

        XCTAssertEqual(model.voiceState, .notConnected)
        let savedRecord = try PracticeRecordStore(directory: directory).load()
        XCTAssertTrue(savedRecord?.markdown.contains("# Practice Record") == true)
    }

    private var sampleSelection: PracticeSelection {
        PracticeSelection(
            extractedVocabulary: ["delighted"],
            extractedSentencePatterns: ["Could you help me?", "I would like coffee."],
            points: [
                PracticePoint(text: "Could you help me?", reason: "Question practice."),
                PracticePoint(text: "delighted", reason: "Vocabulary practice."),
                PracticePoint(text: "I would like coffee.", reason: "Sentence practice.")
            ],
            openingGreeting: "Hi!"
        )
    }

    private func temporaryMarkdownDirectory() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
    }
}

@MainActor
private final class AllowingRealtimeVoiceService: RealtimeVoiceService {
    func start(selection: PracticeSelection, markdown: MarkdownDocument) async throws {}

    func stop() async {}
}
