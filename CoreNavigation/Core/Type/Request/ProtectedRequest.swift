public struct ProtectedRequest<BaseRequest: Request, ProtectionSpaceType: ProtectionSpace>: Request {
    public var configuration: Configuration
    let base: BaseRequest
    let protectionSpace: ProtectionSpaceType

    public func navigate() {
        let resolver = Resolver<Void>.init(onComplete: { (boolean) in
            self.base.navigate()
        }, onError: { (error) in
            
        })
        self.protectionSpace.protect(with: resolver)
    }
}
