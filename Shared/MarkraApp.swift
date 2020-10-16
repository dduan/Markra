import SwiftUI
import ComposableArchitecture

@main
struct MarkraApp: App {
    var body: some Scene {
        MarkraScene()
    }
}

struct FocusedAppStoreKey: FocusedValueKey {
    typealias Value = (AppAction) -> Void
}

extension FocusedValues {
    var appStore: FocusedAppStoreKey.Value? {
        get { self[FocusedAppStoreKey.self] }
        set { self[FocusedAppStoreKey.self] = newValue }
    }
}

class DocumentStoreMap {
    var map: [UUID: Store<AppState, AppAction>] = [:]
}

struct MarkraScene: Scene {
    var storeCache = DocumentStoreMap()
    @FocusedValue(\.appStore) var focusedAppStore: ((AppAction) -> Void)?

    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument()) { file -> AppView in
            let store = storeCache.map[file.document.id] ?? makeAppStore(document: file.$document)
            storeCache.map[file.document.id] = store

            return AppView(store: store) {
                storeCache.map[file.document.id] = nil
            }
        }
        .commands {
            AppCommands(focusedStore: _focusedAppStore)
        }
    }
}

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
                #if os(macOS)
                NSWorkspace.shared.open(URL(string: "https://duan.ca/Markra")!)
                #else
                UIApplication.shared.open(URL(string: "https://duan.ca/Markra")!)
                #endif
            }
            .keyboardShortcut("?", modifiers: .command)
        }
    }
}
