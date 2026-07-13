import Foundation

final class MarkdownStore {
    private let directory: URL
    private var fileURL: URL { directory.appendingPathComponent("markdown-document.json") }

    init(directory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]) {
        self.directory = directory
    }

    func load() throws -> MarkdownDocument? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }

        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(MarkdownDocument.self, from: data)
    }

    @discardableResult
    func save(title: String, body: String) throws -> MarkdownDocument {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        let document = MarkdownDocument(title: title, body: body)
        let data = try JSONEncoder().encode(document)
        try data.write(to: fileURL, options: [.atomic])
        return document
    }

    func delete() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        try FileManager.default.removeItem(at: fileURL)
    }
}
