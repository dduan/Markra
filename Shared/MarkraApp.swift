import SwiftUI

@main
struct MarkraApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: appStore)
        }
    }
}
