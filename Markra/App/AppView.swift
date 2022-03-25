import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>
    let cleanUp: () -> Void
    var body: some View {
        WithViewStore(store) { viewStore in
            EditorView(store: store.scope(state: \.editor, action: { .editor($0) }))
                .focusedValue(\.appStore, viewStore.send)
                .toolbar(content: { AppToolbar(viewStore: viewStore) })
                .onDisappear(perform: cleanUp)
        }

    }
}

#if DEBUG
let testAppStore = Store<AppState, AppAction>(
    initialState: .init(editor: EditorState(markdown: "Hello", jira: "World", isTranslating: false)),
    reducer: appReducer,
    environment: AppEnvironment.testing()
)

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: testAppStore, cleanUp: {})
    }
}
#endif
