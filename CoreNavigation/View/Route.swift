import SwiftUI

public struct Route<Label: View>: View {
    @EnvironmentObject var navigation: Navigation
    
    let matchable: Matchable
    let build: ((RouteRequest) -> Request)?
    let label: () -> Label
    
    public init(_ url: URL, _ build: ((RouteRequest) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
        self.matchable = url
        self.build = build
        self.label = label
    }
    
    public init(_ string: String, _ build: ((RouteRequest) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
        self.matchable = string
        self.build = build
        self.label = label
    }
    
    public var body: some View {
        Button(action: {
            self.request().push()
        }) {
            label()
        }
    }
    
    private func request() -> Request {
        let request = self.navigation.request(matchable: matchable)
        
        if
            let request = request as? RouteRequest,
            let build = self.build
        {
            return build(request)
        }
        
        return request
    }
}
