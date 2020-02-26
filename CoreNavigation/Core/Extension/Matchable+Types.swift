extension String: Matchable {
    public var uri: String { self }
}

extension URL: Matchable {
    public var uri: String { absoluteString }
}
