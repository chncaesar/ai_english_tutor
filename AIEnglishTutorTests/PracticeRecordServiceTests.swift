import XCTest
@testable import AIEnglishTutor

final class PracticeRecordServiceTests: XCTestCase {
    func testGeneratePracticeRecordMarkdownContainsRequiredSections() {
        let service = PracticeRecordService()
        let markdown = MarkdownDocument(title: "lesson.md", body: "# Lesson")
        let selection = PracticeSelection(
            extractedVocabulary: ["classroom"],
            extractedSentencePatterns: ["What's in the classroom?"],
            points: [
                PracticePoint(text: "classroom", reason: "Vocabulary"),
                PracticePoint(text: "What's in the classroom?", reason: "Question"),
                PracticePoint(text: "There is a light.", reason: "Sentence")
            ],
            openingGreeting: "Hi!"
        )
        let logs = [VoiceSessionLog(role: .tutor, text: "Try: There is a light.")]

        let record = service.generate(markdown: markdown, selection: selection, logs: logs)

        XCTAssertTrue(record.markdown.contains("# Practice Record"))
        XCTAssertTrue(record.markdown.contains("## Practiced Vocabulary And Sentence Patterns"))
        XCTAssertTrue(record.markdown.contains("classroom"))
        XCTAssertTrue(record.markdown.contains("## Suggested Next Practice"))
    }
}
