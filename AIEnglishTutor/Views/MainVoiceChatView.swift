import SwiftUI

struct MainVoiceChatView: View {
    @EnvironmentObject private var model: AppModel
    @State private var isSettingsPresented = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                if model.markdownDocument == nil {
                    emptyMarkdownState
                } else {
                    voiceState
                }

                Spacer()
            }
            .padding(24)
            .navigationTitle("英语语音练习")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("设置") { isSettingsPresented = true }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView().environmentObject(model)
            }
        }
    }

    private var emptyMarkdownState: some View {
        VStack(spacing: 16) {
            Text("请先上传 Markdown 课程")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("语音老师需要课程内容，才能选择三个练习点。")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("打开设置") { isSettingsPresented = true }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
    }

    private var voiceState: some View {
        VStack(spacing: 18) {
            Text(statusText).font(.caption.bold()).foregroundStyle(statusColor)
            Text(model.markdownDocument?.title ?? "英语语音练习")
                .font(.title.bold())
                .multilineTextAlignment(.center)

            if let selection = model.practiceSelection {
                LazyVGrid(columns: practicePointColumns, spacing: 8) {
                    ForEach(selection.points) { point in
                        Text(point.text)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.85)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial, in: Capsule())
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                Text("可以开始准备三个练习点。")
                    .foregroundStyle(.secondary)
            }

            if model.isPracticeTimeLimitReached {
                Text("本次练习已达到 20 分钟，请结束并保存练习记录。")
                    .font(.footnote)
                    .foregroundStyle(.orange)
                    .multilineTextAlignment(.center)
            }

            if model.latestPracticeRecord != nil {
                Text("最近一次练习记录已保存到本机 Markdown。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            VoiceOrbView(state: model.voiceState)

            Button(primaryButtonTitle) {
                Task {
                    if model.voiceState == .listening || model.isPracticeTimeLimitReached {
                        await model.finishVoicePractice()
                    } else if model.practiceSelection == nil {
                        await model.preparePractice()
                    } else {
                        await model.startVoicePractice()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private var statusText: String {
        switch model.voiceState {
        case .notConnected:
            "未连接"
        case .connecting:
            "连接中"
        case .listening:
            "正在听"
        case .speaking:
            "正在说"
        case .error(let message):
            message
        }
    }

    private var statusColor: Color {
        switch model.voiceState {
        case .error:
            .red
        default:
            .green
        }
    }

    private var primaryButtonTitle: String {
        if model.voiceState == .listening || model.isPracticeTimeLimitReached {
            return "结束并保存记录"
        }

        return model.practiceSelection == nil ? "准备练习" : "开始语音练习"
    }

    private var practicePointColumns: [GridItem] {
        [GridItem(.adaptive(minimum: 96), spacing: 8)]
    }
}
