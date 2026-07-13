import XCTest
@testable import AIEnglishTutor

final class PracticePreparationServiceTests: XCTestCase {
    @MainActor
    func testLocalFallbackSelectsExactlyThreePracticePoints() async throws {
        let service = PracticePreparationService(client: LocalPracticePreparationClient())
        let markdown = MarkdownDocument(title: "lesson.md", body: """
        # My Classroom
        ## Vocabulary
        - classroom
        - blackboard
        ## Sentence Patterns
        - What's in the classroom?
        - There is a light.
        """)

        let selection = try await service.prepare(from: markdown)

        XCTAssertEqual(selection.points.count, 3)
        XCTAssertTrue(selection.extractedVocabulary.contains("classroom"))
        XCTAssertFalse(selection.openingGreeting.isEmpty)
    }
}
