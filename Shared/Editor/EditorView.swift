import ComposableArchitecture
import SwiftUI

let kMarkdownPlaceholderText = "Enter Markdown here…"
let kJiraPlaceholderText = "Plaintext format JIRA appears here…"

struct EditorView: View {
    let store: Store<EditorState, EditorAction>
    var mainBody: some View {
        WithViewStore(store) { viewStore in
            Group {
                ZStack {
                    TextEditor(text: viewStore.binding(get: \.markdown, send: { .editMarkdown($0) }))
                        .onAppear {
                            // HACK: for some reason the first character change causes significant delay (flicker, e.g. enter the first character, it disappears for a second, then comes back. If more than 1 character is entered while the first is disappearing, it'd be gone).
                            let text = viewStore.markdown
                            viewStore.send(.editMarkdown(" "))
                            viewStore.send(.editMarkdown(text))
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
    var body: some View {
        VStack {
            if AppLayout.basedOnUITraits == .wide {
                Spacer().frame(height: 1) // HACK: without this, the app doesn't layout correctly on iOS.
                HStack { mainBody }
            } else {
                VStack { mainBody }
            }
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
