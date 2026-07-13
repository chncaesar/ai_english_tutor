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
            .navigationTitle("English Voice")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Settings") { isSettingsPresented = true }
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView().environmentObject(model)
            }
        }
    }

    private var emptyMarkdownState: some View {
        VStack(spacing: 16) {
            Text("Upload a Markdown lesson first")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            Text("The voice tutor needs lesson content before it can choose three practice points.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Open Settings") { isSettingsPresented = true }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
        }
    }

    private var voiceState: some View {
        VStack(spacing: 18) {
            Text(statusText).font(.caption.bold()).foregroundStyle(statusColor)
            Text(model.markdownDocument?.title ?? "English Voice")
                .font(.title.bold())
                .multilineTextAlignment(.center)

            if let selection = model.practiceSelection {
                HStack {
                    ForEach(selection.points) { point in
                        Text(point.text)
                            .font(.caption)
                            .padding(8)
                            .background(.thinMaterial, in: Capsule())
                    }
                }
            } else {
                Text("Ready to prepare three practice points.")
                    .foregroundStyle(.secondary)
            }

            VoiceOrbView(state: model.voiceState)

            Button(primaryButtonTitle) {
                Task { await model.preparePractice() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private var statusText: String {
        switch model.voiceState {
        case .notConnected:
            "Not connected"
        case .connecting:
            "Connecting"
        case .listening:
            "Listening"
        case .speaking:
            "Speaking"
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
        model.practiceSelection == nil ? "Prepare Practice" : "Start Voice Practice"
    }
}
