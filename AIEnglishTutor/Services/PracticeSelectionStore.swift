import Foundation

final class PracticeSelectionStore {
    private let directory: URL
    private var fileURL: URL { directory.appendingPathComponent("latest-practice-selection.json") }

    init(directory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]) {
        self.directory = directory
    }

    func load() throws -> PracticeSelection? {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return nil }

        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(PracticeSelection.self, from: data)
    }

    func save(_ selection: PracticeSelection) throws {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)

        let data = try JSONEncoder().encode(selection)
        try data.write(to: fileURL, options: [.atomic])
    }

    func delete() throws {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }

        try FileManager.default.removeItem(at: fileURL)
    }
}
