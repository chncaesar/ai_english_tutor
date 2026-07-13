import Foundation

@MainActor
protocol RealtimeVoiceService {
    func start(selection: PracticeSelection, markdown: MarkdownDocument) async throws
    func stop() async
}

enum RealtimeVoiceError: Error, Equatable {
    case unsupportedByChatGPTPlusProOAuth
    case connectionFailed
    case microphoneUnavailable
}

@MainActor
final class StubRealtimeVoiceService: RealtimeVoiceService {
    func start(selection: PracticeSelection, markdown: MarkdownDocument) async throws {
        guard selection.points.count == 3 else { throw RealtimeVoiceError.connectionFailed }
    }

    func stop() async {}
}
