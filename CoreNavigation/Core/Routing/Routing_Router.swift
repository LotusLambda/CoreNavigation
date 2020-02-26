extension Routing {
    class Router {
        static let instance = Router()
        
        private var registrations: [String: Registration] = [:]
        
        func register<T: Routable>(routableType: T.Type) {
            register(destinationType: routableType, patterns: routableType.routePatterns)
        }

        func register(destinationType: AnyDestination.Type, patterns: [String]) {
            let registrations = patterns.map { (pattern) -> (String, Registration) in
                (pattern, Registration(destinationType: destinationType, patterns: patterns))
            }
            
            self.registrations.merge(registrations) { $1 }
        }

        func unregister(destinationType: AnyDestination.Type) {
            registrations = registrations.filter { (element) -> Bool in
                element.value.destinationType == destinationType
            }
        }
        
        func unregister(pattern: String) {
            registrations[pattern] = nil
        }
        
        func match(for matchable: Matchable) -> Routing.RouteMatch? {
            var parameters: [String: Any]?
            var matchedPattern: String?
            
            let value = registrations.first { element in
                matchable.matches(pattern: element.key, parameters: &parameters, matchedPattern: &matchedPattern)
            }
            
            guard let registration = value?.value else { return nil }
            
            return Routing.RouteMatch(destinationType: registration.destinationType, parameters: parameters, pattern: matchedPattern!)
        }
    }
}

private extension Routing.Router {
    struct Registration {
        let destinationType: AnyDestination.Type
        let patterns: [String]
    }
}
