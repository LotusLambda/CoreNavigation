extension Request {
    public func protect<T: ProtectionSpace>(with protectionSpace: T) -> ProtectedRequest<Self, T> {
        ProtectedRequest(configuration: configuration, base: self, protectionSpace: protectionSpace)
    }
}
