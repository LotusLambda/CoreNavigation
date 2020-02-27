public struct ProtectedRequest<BaseRequest: Request, ProtectionSpaceType: ProtectionSpace>: Request {
    public var configuration: Configuration
    let base: BaseRequest
    let protectionSpace: ProtectionSpaceType

    public func push() {
        let resolver = Resolver<Void>.init(route: nil, onComplete: { (boolean) in
            self.base.push()
        }, onError: { (error) in
            fatalError()
        })
        self.protectionSpace.protect(with: resolver)
    }
    
    public func sheet() {
        let resolver = Resolver<Void>.init(route: nil, onComplete: { (boolean) in
            self.base.sheet()
        }, onError: { (error) in
            fatalError()
        })
        self.protectionSpace.protect(with: resolver)
    }
}
