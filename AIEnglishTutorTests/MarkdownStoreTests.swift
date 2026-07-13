import XCTest
@testable import AIEnglishTutor

final class MarkdownStoreTests: XCTestCase {
    func testSaveLoadAndDeleteMarkdown() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let store = MarkdownStore(directory: directory)

        let saved = try store.save(title: "lesson.md", body: "# Lesson\n- classroom")
        XCTAssertEqual(saved.title, "lesson.md")

        let loaded = try store.load()
        XCTAssertEqual(loaded?.body, "# Lesson\n- classroom")

        try store.delete()
        XCTAssertNil(try store.load())
    }
}
