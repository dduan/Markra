import ComposableArchitecture

struct AppEnvironment {
    let mainQueue = DispatchQueue.main.eraseToAnyScheduler()
    let backgroundQueue = DispatchQueue.global().eraseToAnyScheduler()
}
