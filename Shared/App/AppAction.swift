enum AppAction {
    case copyJira
    case pasteMarkdown
    case updateMarkdown(String)
    case deleteAll
    case editor(EditorAction)
}
