final class IUOBox<T> {
    var value: T!
    init() {}
    var isReady: Bool {
        return value != nil
    }
}
