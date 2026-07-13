import Foundation

final class PracticeRecordService {
    func generate(markdown: MarkdownDocument, selection: PracticeSelection, logs: [VoiceSessionLog]) -> PracticeRecord {
        let pointLines = selection.points.map { "- \($0.text)" }.joined(separator: "\n")
        let logLines = logs.map { "- [\($0.role.rawValue)] \($0.text)" }.joined(separator: "\n")
        let content = """
        # Practice Record

        Date: \(Date().formatted(date: .abbreviated, time: .shortened))

        Source content title: \(markdown.title)

        ## Practiced Vocabulary And Sentence Patterns

        \(pointLines)

        ## Mistakes Corrected

        \(logLines.isEmpty ? "- No transcript events available." : logLines)

        ## Expressions Repeated For Practice

        \(pointLines)

        ## Short Summary

        Practiced a short realtime voice session based on the uploaded Markdown.

        ## Suggested Next Practice

        Repeat the same three practice points in a new short voice session.
        """

        return PracticeRecord(markdown: content)
    }
}
