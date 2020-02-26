import SwiftUI

public struct Link<DestinationType: Destination, Label: View>: View {
    @EnvironmentObject var navigation: Navigation
    
    let destination: DestinationType
    let build: ((DestinationRequest<DestinationType>) -> Request)?
    let label: () -> Label
    
    public init(_ destination: DestinationType, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.build = build
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
        let request = self.navigation.request(destination)
        
        if
            let request = request as? DestinationRequest<DestinationType>,
            let build = self.build
        {
            return build(request)
        }
        
        return request
    }
}

extension Link {
    public init<T>(_ view: @escaping () -> T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<T>  {
        self.destination = ViewDestination(content: view)
        self.build = build
        self.label = label
    }
    
    @inlinable public init<T>(_ view: T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<T>  {
        self.init({ view }, build, label: label)
    }
}
