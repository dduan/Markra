import SwiftUI

struct AppCommands: Commands {
    let focusedStore:  FocusedValue<(AppAction) -> Void>

    var body: some Commands {
        CommandGroup(before: .pasteboard) {
            Button("Copy Jira") {
                focusedStore.wrappedValue?(.copyJira)
            }
            .keyboardShortcut("c", modifiers: [.shift, .command])
            Button("Delete All") {
                focusedStore.wrappedValue?(.deleteAll)
            }
            .keyboardShortcut("d", modifiers: [.shift, .command])
        }

        CommandGroup(replacing: .help) {
            Button("Markra Help") {
                NSWorkspace.shared.open(URL(string: "https://duan.ca/Markra")!)
            }
            .keyboardShortcut("?", modifiers: .command)
        }
    }
}
