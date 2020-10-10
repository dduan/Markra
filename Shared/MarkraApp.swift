import SwiftUI
import ComposableArchitecture

@main
struct MarkraApp: App {
    var body: some Scene {
        MarkraScene()
    }
}

struct MarkraScene: Scene {
    var appStoreStorage = IUOBox<Store<AppState, AppAction>>()
    var appStore: Store<AppState, AppAction> {
        appStoreStorage.value
    }

    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument()) { file -> AppView in
            self.appStoreStorage.value = makeAppStore(document: file.$document)
            return AppView(store: self.appStore)
        }
        .commands {
            CommandGroup(before: .pasteboard) {
                Button("Copy Jira") {
                    ViewStore(appStore).send(.copyJira)
                }
                .keyboardShortcut("c", modifiers: [.shift, .command])
                Button("Delete All") {
                    ViewStore(appStore).send(.deleteAll)
                }
                .keyboardShortcut("d", modifiers: [.shift, .command])
            }
        }
    }
}
