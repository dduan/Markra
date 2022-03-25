import ComposableArchitecture
import SwiftUI

struct AppEnvironment {
    let mainQueue: () -> AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
    let backgroundQueue: () -> AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
    @Binding var document: MarkdownDocument

    static func production(document: Binding<MarkdownDocument>) -> Self {
        .init(
            mainQueue: { DispatchQueue.main.eraseToAnyScheduler() },
            backgroundQueue: { DispatchQueue.global().eraseToAnyScheduler() },
            document: document
        )
    }

    static func testing() -> Self {
        .init(
            mainQueue: { DispatchQueue.main.eraseToAnyScheduler() },
            backgroundQueue: { DispatchQueue.main.eraseToAnyScheduler() },
            document: .empty(value: .init())
        )
    }
}
