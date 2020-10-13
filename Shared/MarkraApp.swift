import SwiftUI
import ComposableArchitecture

@main
struct MarkraApp: App {
    var body: some Scene {
        MarkraScene()
    }
}

class DocumentStoreMap {
    var map: [UUID: Store<AppState, AppAction>] = [:]
}

struct MarkraScene: Scene {
    var storeCache = DocumentStoreMap()

    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument()) { file -> AppView in
            let store = storeCache.map[file.document.id] ?? makeAppStore(document: file.$document)
            storeCache.map[file.document.id] = store

            return AppView(store: store) {
                storeCache.map[file.document.id] = nil
            }
        }
        .commands {
            CommandGroup(replacing: .help) {
                Button("Markra Help") {
                    NSWorkspace.shared.open(URL(string: "https://duan.ca/Markra")!)
                }
                .keyboardShortcut("?", modifiers: .command)
            }
        }
//        .commands {
//            CommandGroup(before: .pasteboard) {
//                Button("Copy Jira") {
//                    ViewStore(appStore).send(.copyJira)
//                }
//                .keyboardShortcut("c", modifiers: [.shift, .command])
//                Button("Delete All") {
//                    ViewStore(appStore).send(.deleteAll)
//                }
//                .keyboardShortcut("d", modifiers: [.shift, .command])
//            }
//        }
    }
}
