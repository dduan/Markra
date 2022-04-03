import AppKit
import ComposableArchitecture
import Introspect
import SwiftUI

let kMarkdownPlaceholderText = "Enter Markdown here…"
let kJiraPlaceholderText = "Plaintext format JIRA appears here…"

struct EditorView: View {
    let store: Store<EditorState, EditorAction>
    @available(macOS 12, *)
    @FocusState var focus: Bool
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 0) {
                ZStack {
                    TextEditor(text: viewStore.binding(get: \.markdown, send: { .editMarkdown($0) }))
                        .introspectTextView { textView in
                            textView.window?.makeFirstResponder(textView)
                            textView.isAutomaticQuoteSubstitutionEnabled = false
                            textView.isAutomaticDashSubstitutionEnabled = false
                        }
                    if viewStore.markdown.isEmpty {
                        Text(kMarkdownPlaceholderText)
                            .foregroundColor(.secondary)
                    }
                }
                Divider()
                ZStack {
                    TextEditor(text: viewStore.binding(get: \.jira, send: .noop))
                    if viewStore.jira.isEmpty && !viewStore.isTranslating {
                        Spacer()
                        Text(kJiraPlaceholderText)
                            .foregroundColor(.secondary)
                    } else if viewStore.isTranslating {
                        ProgressView()
                    }
                }
            }
            .font(.system(.body, design: .monospaced))
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorView(
                store: .init(
                    initialState: .init(
                        markdown: "Hello",
                        jira: "Hello Jira",
                        isTranslating: false
                    ),
                    reducer: .empty,
                    environment: AppEnvironment.testing()
                )
            )
            EditorView(
                store: .init(
                    initialState: .init(
                        markdown: "Hello",
                        jira: "Hello Jira",
                        isTranslating: true
                    ),
                    reducer: .empty,
                    environment: AppEnvironment.testing()
                )
            )
        }
    }
}
