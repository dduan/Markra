import ComposableArchitecture
import SwiftUI

struct FocusedAppStoreKey: FocusedValueKey {
    typealias Value = UUID
}

extension FocusedValues {
    var documentID: FocusedAppStoreKey.Value? {
        get { self[FocusedAppStoreKey.self] }
        set { self[FocusedAppStoreKey.self] = newValue }
    }
}

struct MarkraScene: Scene {
    class DocumentStoreMap {
        var map: [UUID: Store<AppState, AppAction>] = [:]
    }

    var storeCache = DocumentStoreMap()
    @FocusedValue(\.documentID) var focusedDocumentID: (FocusedAppStoreKey.Value)?
    var activeViewStore: ViewStore<AppState, AppAction>? {
        self.focusedDocumentID.flatMap { self.storeCache.map[$0].map(ViewStore.init) }
    }

    var body: some Scene {
        DocumentGroup(newDocument: MarkdownDocument()) { file -> AppView in
            let store = storeCache.map[file.document.id] ?? makeAppStore(document: file.$document)
            storeCache.map[file.document.id] = store

            return AppView(store: store) {
                storeCache.map[file.document.id] = nil
            }
        }
        .commands {
            CommandGroup(before: .pasteboard) {
                Button("Copy Jira") {
                    self.activeViewStore?.send(.copyJira)
                }
                .keyboardShortcut("c", modifiers: [.shift, .command])
                Button("Delete All") {
                    self.activeViewStore?.send(.deleteAll)
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
}
