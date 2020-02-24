public class Resolver<T> {
    let onComplete: (T) -> Void
    let onError: (Error) -> Void
    
    init(onComplete: @escaping (T) -> Void, onError: @escaping (Error) -> Void) {
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
