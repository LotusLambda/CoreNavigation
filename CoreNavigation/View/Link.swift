import SwiftUI

public struct Link<DestinationType: Destination, Label: View>: View {
    @EnvironmentObject var navigation: Navigation
    
    let destination: () -> DestinationType
    let build: ((DestinationRequest<DestinationType>) -> Request)?
    let label: () -> Label

    public var body: some View {
        Button(action: {
            self.request().push()
        }) {
            label()
        }
    }
    
    private func request() -> Request {
        let request = self.navigation.request(destination())
        
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
    public init(_ destination: @escaping () -> DestinationType, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.build = build
        self.label = label
    }
    
    @inlinable public init(_ destination: DestinationType, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) {
        self.init({ destination }, build, label: label)
    }
    
    @inlinable public init<T>(_ view: @escaping () -> T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<T> {
        self.init({ ViewDestination(content: view) }, build, label: label)
    }
    
    @inlinable public init<T>(_ view: T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<T> {
        self.init({ view }, build, label: label)
    }
    
    @inlinable public init<T>(_ viewController: @escaping () -> T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<ViewControllerWrapper<T>> {
        self.init(ViewControllerWrapper(viewController: viewController()), build, label: label)
    }
    
    @inlinable public init<T>(_ viewController: T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<ViewControllerWrapper<T>>  {
        self.init({ viewController }, build, label: label)
    }
    
    @inlinable public init<T>(_ view: @escaping () -> T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<ViewWrapper<T>> {
        self.init(ViewWrapper(view: view()), build, label: label)
    }
    
    @inlinable public init<T>(_ view: T, _ build: ((DestinationRequest<DestinationType>) -> Request)?, @ViewBuilder label: @escaping () -> Label) where DestinationType == ViewDestination<ViewWrapper<T>>  {
        self.init({ view }, build, label: label)
    }
}
