public enum ResolverError: Swift.Error {
    case resolverNotSynchronous
}

extension Destination {
    public func view() throws -> ViewType {
        var view: ViewType?
        
        resolveView(with: .init(route: nil, onComplete: { (_view) in
            view = _view
        }, onError: { (error) in
            
        }))
        
        guard let output = view else {
            throw ResolverError.resolverNotSynchronous
        }
        
        return output
    }
}
