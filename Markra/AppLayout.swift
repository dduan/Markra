import SwiftUI

enum AppLayout: Equatable {
    case narrow
    case wide

    static var basedOnUITraits: Self {
        #if !os(macOS)
        let traits = UITraitCollection()
        let idiom = UIDevice.current.userInterfaceIdiom
        if idiom == .pad && traits.horizontalSizeClass == .compact || idiom == .phone {
            return .narrow
        }
        #endif


        return .wide
    }
}
