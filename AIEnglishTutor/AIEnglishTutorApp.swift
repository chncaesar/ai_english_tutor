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
                        DisclosureGroup("What will be stored?") {
                            Text("ChatGPT tokens are stored securely on this device. v0.0.1 does not include a child profile, reports, cloud sync, or a public release.")
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
