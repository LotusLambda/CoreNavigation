extension Navigation.Builder.To {
    @discardableResult public func stateRestorable(with identifier: String, until expirationDate: Date = Date.distantFuture) -> Self {
        queue.sync { configuration.stateRestorationBlock = { (identifier, expirationDate) } }
        
        return self
    }
}