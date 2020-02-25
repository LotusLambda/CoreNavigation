public class Resolver<T> {
    public internal(set) var route: Routing.Route?
    let onComplete: (T) -> Void
    let onError: (Error) -> Void
    
    init(route: Routing.Route?, onComplete: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
        self.route = route
        self.onComplete = onComplete
        self.onError = onError
    }
    
    public func complete(_ view: T) {
        self.onComplete(view)
    }
    
    public func error(_ error: Error) {
        self.onError(error)
    }
}
