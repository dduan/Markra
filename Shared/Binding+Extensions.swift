import SwiftUI

extension Binding {
    static func empty(value: Value) -> Self {
        .init(
            get: { value },
            set: { _ in }
        )
    }
}
