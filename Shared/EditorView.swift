import ComposableArchitecture
import SwiftUI

let kMarkdownPlaceholderText = "Enter Markdown here…"
let kJiraPlaceholderText = "Plaintext format JIRA will appear here…"

struct EditorView: View {
    let store: Store<EditorState, EditorAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                TextEditor(
                    text: .init(
                        get: {
                            viewStore.markdown.isEmpty ? kMarkdownPlaceholderText : viewStore.markdown
                        },
                        set: { text in
                            var markdown = text
                            if viewStore.markdown.isEmpty {
                                markdown = String(text.dropFirst(kMarkdownPlaceholderText.count))
                            }
                            viewStore.send(.editMarkdown(markdown))
                        }
                    )
                )
                .foregroundColor(viewStore.markdown.isEmpty ? .secondary : .primary)
                Divider()
                ZStack {
                    if viewStore.isTranslating {
                        ProgressView().progressViewStyle(LinearProgressViewStyle())
                    }

                    TextEditor(
                        text: .init(
                            get: {
                                viewStore.jira.isEmpty ? kJiraPlaceholderText : viewStore.jira
                            },
                            set: { _ in viewStore.send(.noop) }
                        )
                    )
                    .foregroundColor(viewStore.jira.isEmpty ? .secondary : .primary)
                }
            }
            .font(.system(.body, design: .monospaced))
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorView(store: .init(initialState: .init(markdown: "Hello", jira: "Hello Jira", isTranslating: false), reducer: .empty, environment: AppEnvironment()))
            EditorView(store: .init(initialState: .init(markdown: "Hello", jira: "Hello Jira", isTranslating: true), reducer: .empty, environment: AppEnvironment()))
        }
    }
}
