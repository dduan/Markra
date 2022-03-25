import ComposableArchitecture
import SwiftUI
import Introspect

let kMarkdownPlaceholderText = "Enter Markdown here…"
let kJiraPlaceholderText = "Plaintext format JIRA appears here…"

typealias NativeTextView = NSTextView

struct EditorView: View {
    let store: Store<EditorState, EditorAction>
    @available(macOS 12, *)
    @FocusState var focus: Bool
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 0) {
                ZStack {
                    if #available(macOS 12.0, *) {
                        TextEditor(text: viewStore.binding(get: \.markdown, send: { .editMarkdown($0) }))
                            .focused($focus)
                    } else {
                        TextEditor(text: viewStore.binding(get: \.markdown, send: { .editMarkdown($0) }))
                            .makeFirstResponder(NativeTextView.self)
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
