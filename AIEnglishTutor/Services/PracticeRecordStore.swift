import Foundation

final class PracticeRecordStore {
    private let directory: URL
    private var fileURL: URL { directory.appendingPathComponent("latest-practice-record.md") }

    init(directory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]) {
        self.directory = directory
    }

    func load() throws -> PracticeRecord? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }

        let markdown = try String(contentsOf: fileURL, encoding: .utf8)
        return PracticeRecord(markdown: markdown)
    }

    func save(_ record: PracticeRecord) throws {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try record.markdown.write(to: fileURL, atomically: true, encoding: .utf8)
    }

    func delete() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        try FileManager.default.removeItem(at: fileURL)
    }
}
