import ComposableArchitecture

let appReducer = Reducer
    .combine(
        editorReducer
            .pullback(
                state: \AppState.editor,
                action: /AppAction.editor,
                environment:  { $0 }
            )
    )

let appStore = Store<AppState, AppAction>(
    initialState: AppState(editor: EditorState()),
    reducer: appReducer,
    environment: AppEnvironment()
)
