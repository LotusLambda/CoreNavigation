/// Used in route matching.
public protocol Matchable {
    /// Route string.
    var uri: String { get }
}

extension Matchable {
    func matches(pattern: String, parameters: inout [String: Any]?, matchedPattern: inout String?) -> Bool {
        guard let regularExpression = try? Routing.RegularExpression(pattern: pattern) else {
            return false
        }
        
        guard regularExpression.matchResult(for: uri, parameters: &parameters) else {
            return false
        }
        
        matchedPattern = pattern
        
        return true
    }
}
