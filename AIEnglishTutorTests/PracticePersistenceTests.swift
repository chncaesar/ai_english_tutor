import XCTest
@testable import AIEnglishTutor

@MainActor
final class PracticePersistenceTests: XCTestCase {
    func testPracticeSelectionPersistsAndLoadsOnStartup() async {
        let directory = temporaryDirectory()
        let selectionStore = PracticeSelectionStore(directory: directory)
        let model = AppModel(
            markdownStore: MarkdownStore(directory: directory),
            practiceSelectionStore: selectionStore,
            practiceRecordStore: PracticeRecordStore(directory: directory)
        )
        model.saveMarkdown(title: "lesson.md", body: "- classroom\n- There is a light.\n- Could you help me?")

        await model.preparePractice()
        let reloaded = AppModel(
            isLoggedIn: true,
            markdownStore: MarkdownStore(directory: directory),
            practiceSelectionStore: selectionStore,
            practiceRecordStore: PracticeRecordStore(directory: directory)
        )

        XCTAssertEqual(reloaded.practiceSelection, model.practiceSelection)
    }

    func testSavingNewMarkdownClearsPersistedPracticeSelectionAndRecord() throws {
        let directory = temporaryDirectory()
        let selectionStore = PracticeSelectionStore(directory: directory)
        let recordStore = PracticeRecordStore(directory: directory)
        let selection = sampleSelection
        try selectionStore.save(selection)
        try recordStore.save(PracticeRecord(markdown: "# Practice Record"))
        let model = AppModel(
            markdownStore: MarkdownStore(directory: directory),
            practiceSelectionStore: selectionStore,
            practiceRecordStore: recordStore
        )

        model.saveMarkdown(title: "new.md", body: "# New")

        XCTAssertNil(model.practiceSelection)
        XCTAssertNil(model.latestPracticeRecord)
        XCTAssertNil(try selectionStore.load())
        XCTAssertNil(try recordStore.load())
    }

    func testPracticeRecordStoreSavesMarkdownFile() throws {
        let directory = temporaryDirectory()
        let store = PracticeRecordStore(directory: directory)
        let record = PracticeRecord(markdown: "# Practice Record\n\n本次练习完成。")

        try store.save(record)

        XCTAssertEqual(try store.load()?.markdown, record.markdown)
    }

    private var sampleSelection: PracticeSelection {
        PracticeSelection(
            extractedVocabulary: ["classroom"],
            extractedSentencePatterns: ["Could you help me?"],
            points: [
                PracticePoint(text: "classroom", reason: "Vocabulary"),
                PracticePoint(text: "Could you help me?", reason: "Question"),
                PracticePoint(text: "There is a light.", reason: "Sentence")
            ],
            openingGreeting: "Hi!"
        )
    }

    private func temporaryDirectory() -> URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
    }
}
