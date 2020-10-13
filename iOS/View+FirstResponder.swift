import SwiftUI
import UIKit
import Introspect

extension View {
    public func makeFirstResponder<T: PlatformView>(_: T.Type) -> some View {
        inject(UIKitIntrospectionView(
            selector: { introspectView in
                guard let viewHost = Introspect.findViewHost(from: introspectView) else {
                    return nil
                }

                return Introspect.previousSibling(containing: T.self, from: viewHost)
            },
            customize: { view in
                view.becomeFirstResponder()
            }
        ))
    }
}
