import Foundation

@MainActor
protocol PracticePreparationClient {
    func prepare(from markdown: MarkdownDocument) async throws -> PracticeSelection
}

@MainActor
final class PracticePreparationService {
    private let client: PracticePreparationClient

    init(client: PracticePreparationClient) {
        self.client = client
    }

    func prepare(from markdown: MarkdownDocument) async throws -> PracticeSelection {
        let selection = try await client.prepare(from: markdown)
        guard selection.points.count == 3 else {
            throw PracticePreparationError.invalidPracticePointCount
        }
        return selection
    }
}

enum PracticePreparationError: Error, Equatable {
    case invalidPracticePointCount
}

final class LocalPracticePreparationClient: PracticePreparationClient {
    func prepare(from markdown: MarkdownDocument) async throws -> PracticeSelection {
        let lines = markdown.body.components(separatedBy: .newlines)
        let bulletItems = lines
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.hasPrefix("-") }
            .map { $0.dropFirst().trimmingCharacters(in: .whitespacesAndNewlines) }

        let vocabulary = bulletItems.filter { !$0.contains("?") && !$0.contains(".") }
        let patterns = bulletItems.filter { $0.contains("?") || $0.contains(".") }
        let candidates = Array((patterns + vocabulary).prefix(3))
        let padded = candidates + Array(repeating: "Tell me about this lesson.", count: max(0, 3 - candidates.count))
        let points = padded.prefix(3).map {
            PracticePoint(text: $0, reason: "来自上传的 Markdown，适合本次口语练习。")
        }

        return PracticeSelection(
            extractedVocabulary: vocabulary,
            extractedSentencePatterns: patterns,
            points: Array(points),
            openingGreeting: "Hi! Today we will practice English from your Markdown lesson."
        )
    }
}
