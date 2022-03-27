import ComposableArchitecture
import SwiftUI

struct FocusedAppStoreKey: FocusedValueKey {
    typealias Value = (AppAction) -> Void
}

extension FocusedValues {
    var appStore: FocusedAppStoreKey.Value? {
        get { self[FocusedAppStoreKey.self] }
        set { self[FocusedAppStoreKey.self] = newValue }
    }
}

struct MarkraScene: Scene {
    class DocumentStoreMap {
        var map: [UUID: Store<AppState, AppAction>] = [:]
    }

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
