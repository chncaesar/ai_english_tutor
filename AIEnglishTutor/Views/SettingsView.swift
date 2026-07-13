import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject private var model: AppModel
    @Environment(\.dismiss) private var dismiss
    @State private var isImporterPresented = false

    private let markdownTypes = [UTType(filenameExtension: "md") ?? .plainText]

    var body: some View {
        NavigationStack {
            List {
                Section("ChatGPT") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("ChatGPT")
                            Text(model.isLoggedIn ? "已登录 Plus/Pro" : "未登录")
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        StatusPillView(
                            text: model.isLoggedIn ? "Active" : "Required",
                            color: model.isLoggedIn ? .green : .orange
                        )
                    }
                }

                Section("Markdown") {
                    if let document = model.markdownDocument {
                        Text(document.title).font(.headline)
                        ScrollView {
                            Text(document.body)
                                .font(.system(.footnote, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 8)
                        }
                        .frame(maxHeight: 220)
                        Button("Upload New Markdown") { isImporterPresented = true }
                        Button("Delete Markdown", role: .destructive) { model.deleteMarkdown() }
                    } else {
                        Text("当前还没有 Markdown 内容，请先上传。")
                            .foregroundStyle(.secondary)
                        Button("Upload Markdown") { isImporterPresented = true }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
            .fileImporter(
                isPresented: $isImporterPresented,
                allowedContentTypes: markdownTypes,
                allowsMultipleSelection: false,
                onCompletion: importMarkdown
            )
        }
    }

    private func importMarkdown(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result, let url = urls.first else { return }
        guard url.startAccessingSecurityScopedResource() else {
            model.voiceState = .error("无法读取 Markdown 文件，请重新选择。")
            return
        }
        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let body = try String(contentsOf: url, encoding: .utf8)
            model.saveMarkdown(title: url.lastPathComponent, body: body)
        } catch {
            model.voiceState = .error("无法读取 Markdown 文件，请重新选择。")
        }
    }
}
