import XCTest
@testable import AIEnglishTutor

@MainActor
final class RealtimeVoiceServiceTests: XCTestCase {
    func testStartVoicePracticeMovesToListeningWithPreparedSelection() async {
        let model = AppModel(markdownStore: MarkdownStore(directory: temporaryMarkdownDirectory()))
        model.saveMarkdown(title: "Lesson", body: "- Could you help me?\n- delighted\n- I would like coffee.")
        model.practiceSelection = PracticeSelection(
            extractedVocabulary: ["delighted"],
            extractedSentencePatterns: ["Could you help me?", "I would like coffee."],
            points: [
                PracticePoint(text: "Could you help me?", reason: "Question practice."),
                PracticePoint(text: "delighted", reason: "Vocabulary practice."),
                PracticePoint(text: "I would like coffee.", reason: "Sentence practice.")
            ],
            openingGreeting: "Hi!"
        )

        await model.startVoicePractice()

        XCTAssertEqual(model.voiceState, AppVoiceState.listening)
    }

    func testStartVoicePracticeRequiresPreparedSelection() async {
        let model = AppModel(markdownStore: MarkdownStore(directory: temporaryMarkdownDirectory()))
        model.saveMarkdown(title: "Lesson", body: "- Could you help me?")

        await model.startVoicePractice()

        XCTAssertEqual(model.voiceState, AppVoiceState.error("当前还没有练习内容，请先准备本次练习。"))
    }

    private func temporaryMarkdownDirectory() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
    }
}
