import ComposableArchitecture
import SwiftUI

struct AppView: View {
    let store: Store<AppState, AppAction>
    var body: some View {
        EditorView(store: store.scope(state: \.editor, action: { .editor($0) }))
    }
}

#if DEBUG
let testAppStore = Store<AppState, AppAction>(
    initialState: .init(editor: EditorState(markdown: "Hello", jira: "World", isTranslating: false)),
    reducer: appReducer,
    environment: AppEnvironment()
)

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(store: testAppStore)
    }
}
#endif
