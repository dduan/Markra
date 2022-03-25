import ComposableArchitecture
import SwiftUI

struct AppToolbar: ToolbarContent {
    let viewStore: ViewStore<AppState, AppAction>
    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button(
                action: {
                    viewStore.send(.pasteMarkdown)
                },
                label: {
                    Image(systemName: "doc.on.clipboard")
                }
            )
            .help("Paste Markdown from clipboard (⇧⌘P)")
            .keyboardShortcut("p", modifiers: [.shift, .command])
        }
        ToolbarItem(placement: .automatic) {
            Button(
                action: {
                    viewStore.send(.copyJira)
                },
                label: {
                    Image(systemName: "doc.on.doc")
                }
            )
            .disabled(viewStore.editor.markdown.isEmpty)
            .help("Copy JIRA text to clipboard (⇧⌘C)")
            .keyboardShortcut("c", modifiers: [.shift, .command])
        }
    }
}
