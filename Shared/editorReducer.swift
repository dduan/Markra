import ComposableArchitecture
import Combine
import Markdown2Jira

let editorReducer = Reducer<EditorState, EditorAction, AppEnvironment> { state, action, env in
    switch action {
    case .editMarkdown(let markdown):
        if markdown == state.markdown {
            return .none
        }

        state.markdown = markdown
        return Effect(value: .editDelayCompleted)
            .debounce(id: "editDelayCompleted", for: 0.3, scheduler: env.mainQueue)

    case .editDelayCompleted:
        state.isTranslating = true
        let markdown = state.markdown
        return Future { complete in
            env.backgroundQueue.schedule {
                let jira = markdown2Jira(markdown)
                env.mainQueue.schedule {
                    complete(.success(.updateJira(jira)))
                }
            }
        }
        .eraseToEffect()
    case .updateJira(let jira):
        state.isTranslating = false
        state.jira = jira
        return .none
    case .noop:
        return .none
    }
}
