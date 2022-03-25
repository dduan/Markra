import ComposableArchitecture
import SwiftUI
import Markdown2Jira
import Combine
import AppKit

let appReducer = Reducer
    .combine(
        editorReducer
            .pullback(
                state: \AppState.editor,
                action: /AppAction.editor,
                environment: { $0 }
            ),
        Reducer { state, action, _ in
            switch action {
            case .copyJira:
                let jiraText = state.editor.jira
                return .fireAndForget {
                    NSPasteboard.general.declareTypes([.string], owner: nil)
                    NSPasteboard.general.setString(jiraText , forType: .string)
                }
            case .pasteMarkdown:
                let existingMarkdown = state.editor.markdown
                return Future { complete in
                    let string = NSPasteboard.general.string(forType: .string)
                    if let string = string {
                        let markdown = existingMarkdown.isEmpty ? string : existingMarkdown + "\n" + string
                        complete(.success(.updateMarkdown(markdown)))
                    }
                }
                .eraseToEffect()
            case .updateMarkdown(let markdown):
                state.editor.markdown = markdown
                state.editor.jira = markdown2Jira(markdown)
                return .none
            case .deleteAll:
                state.editor.markdown = ""
                state.editor.jira = ""
                return .none

            case .editor:
                return .none
            }
        }
    )

func makeAppStore(document: Binding<MarkdownDocument>) ->  Store<AppState, AppAction> {
    let initialMarkdown = document.wrappedValue.text
    return Store<AppState, AppAction>(
        initialState: AppState(
            editor: EditorState(
                markdown: initialMarkdown,
                jira: markdown2Jira(initialMarkdown)
            )
        ),
        reducer: appReducer,
        environment: AppEnvironment.production(document: document)
    )
}
