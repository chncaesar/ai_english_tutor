import SwiftUI

@main
struct AIEnglishTutorApp: App {
    @StateObject private var model = AppModel()

    var body: some Scene {
        WindowGroup {
            Group {
                switch model.route {
                case .firstUseLogin:
                    Text("请先登录 ChatGPT")
                        .font(.title2.bold())
                case .mainVoiceChat:
                    Text("English Voice")
                        .font(.title2.bold())
                }
            }
            .environmentObject(model)
        }
    }
}
