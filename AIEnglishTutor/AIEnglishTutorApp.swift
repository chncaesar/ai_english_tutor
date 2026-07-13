import SwiftUI

@main
struct AIEnglishTutorApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch model.route {
                case .firstUseLogin:
                    VStack(spacing: 16) {
                        Text("登录后开始语音练习")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        Text("使用 ChatGPT Plus/Pro 账号完成登录后，才能基于 Markdown 课程进行实时口语练习。")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        if case .error(let message) = model.voiceState {
                            Text(message)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                        Button("使用 ChatGPT 继续") {
                            Task { await model.signInWithChatGPT() }
                        }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        DisclosureGroup("本机会保存什么？") {
                            Text("正式登录完成后，仅在本机安全保存必要登录凭据。v0.0.1 不包含儿童档案、报告、云同步或公开发布。")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .padding(.top, 8)
                        }
                        .font(.subheadline.weight(.semibold))
                        .padding(.top, 8)
                    }
                    .padding(24)
                case .mainVoiceChat:
                    MainVoiceChatView()
                }
            }
            .environmentObject(model)
        }
    }
}
