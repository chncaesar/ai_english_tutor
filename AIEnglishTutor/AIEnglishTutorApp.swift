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
                        Text("Sign in to practice English by voice")
                            .font(.title.bold())
                            .multilineTextAlignment(.center)
                        Text("Use your ChatGPT Plus/Pro account to start realtime speaking practice from your Markdown lesson.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Continue with ChatGPT") { model.markLoggedIn() }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
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
