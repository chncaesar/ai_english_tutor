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
        throw RealtimeVoiceError.unsupportedByChatGPTPlusProOAuth
    }

    func stop() async {}
}
