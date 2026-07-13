import SwiftUI

struct VoiceOrbView: View {
    let state: AppVoiceState

    var body: some View {
        ZStack {
            Circle()
                .fill(.green.opacity(0.18))
                .frame(width: 178, height: 178)
            Circle()
                .fill(.green.opacity(0.28))
                .frame(width: 142, height: 142)
            Circle()
                .fill(.green.gradient)
                .frame(width: 112, height: 112)
                .overlay(Text(symbol).font(.largeTitle.bold()).foregroundStyle(.white))
        }
        .accessibilityLabel(accessibilityText)
    }

    private var symbol: String {
        switch state {
        case .notConnected:
            "○"
        case .connecting:
            "…"
        case .listening:
            "🎙"
        case .speaking:
            "⌁"
        case .error:
            "!"
        }
    }

    private var accessibilityText: String {
        switch state {
        case .notConnected:
            "未连接"
        case .connecting:
            "正在连接语音"
        case .listening:
            "正在听你说话"
        case .speaking:
            "正在播放回答"
        case .error:
            "语音连接错误"
        }
    }
}
