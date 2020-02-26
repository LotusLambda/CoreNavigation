    import SwiftUI

    public struct Route<Label: View>: View {
        @EnvironmentObject var navigation: Navigation
        
        let matchable: Matchable
        let configure: ((RouteRequest) -> Request)?
        let label: () -> Label
        
        public init(_ url: URL, configure: ((RouteRequest) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
            self.matchable = url
            self.configure = configure
            self.label = label
        }
        
        public init(_ string: String, configure: ((RouteRequest) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
            self.matchable = string
            self.configure = configure
            self.label = label
        }
        
        public var body: some View {
            Button(action: {
                self
                    .request()
                    .navigate()
            }) {
                label()
            }
        }
        
        private func request() -> Request {
            let request = self.navigation.request(matchable: matchable)
            
            if
                let routeRequest = request as? RouteRequest,
                let configure = self.configure
            {
                return configure(routeRequest)
            }
            
            return request
        }
    }
