import ComposableArchitecture
import SwiftUI

struct AppToolbar: ToolbarContent {
    let viewStore: ViewStore<AppState, AppAction>
    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            Button(
                action: {
                    viewStore.send(.copyJira)
                },
                label: {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Jira")
                    }
                }
            )
            .disabled(viewStore.editor.jira.isEmpty)
            .help("Copy JIRA text to clipboard")
        }
    }
}
