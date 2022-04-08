import Foundation

struct AppState: Hashable {
    var documentID: UUID
    var editor: EditorState
}
