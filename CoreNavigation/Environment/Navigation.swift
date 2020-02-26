import SwiftUI

class Stack {
    struct Item {
        let view: AnyView
        let configuration: Configuration?
    }
    
    var items: [Item] = []
    
    func push(view: AnyView, configuration: Configuration?) {
        items.append(.init(view: view, configuration: configuration))
    }
    
    func pop() -> Item? {
        items.popLast()
    }
}

public class Navigation: ObservableObject {
    enum Direction {
        case forward
        case backward
    }
    
    private let stack = Stack()
    private(set) var currentView: AnyView
    private(set) var previousView: AnyView?
    @Published private(set) var direction: Direction?
    
    init<ViewType: View>(currentView: ViewType) {
        self.currentView = AnyView(currentView)
    }

    public func push<ViewType: View>(view: ViewType) {
        push(view: view, configuration: nil)
    }
    
    func push<ViewType: View>(view: ViewType, configuration: Configuration?) {
        stack.push(view: currentView, configuration: configuration)
        
        previousView = currentView
        
        currentView = configure(view: view, with: configuration)
        
        withAnimation(configuration?.animation) {
            direction = .forward
        }
    }
    
    public func pop() {
        guard let last = stack.pop() else { return }
        
        previousView = stack.items.last?.view
        
        currentView = last.view
        
        withAnimation(last.configuration?.animation) {
            direction = .backward
        }
    }
    
    private func configure<ViewType: View>(view: ViewType, with configuration: Configuration?) -> AnyView {
        var view = AnyView(view)
        
        if let transition = configuration?.transition {
            view = AnyView(view.transition(transition))
        }
        
        return view
    }
}

// MARK: Navigation requests

extension Navigation {
    public func request<DestinationType: Destination>(_ destination: DestinationType) -> some Request {
        DestinationRequest(navigation: self, configuration: Configuration(), destination: destination)
    }
    
    @inlinable public func request<ViewType: View>(_ view: @escaping () -> ViewType) -> some Request {
        request(ViewDestination(content: view))
    }
    
    @inlinable public func request<ViewType: View>(_ view: ViewType) -> some Request {
        request { view }
    }
    
    @inlinable public func request<ViewControllerType: UIViewController>(_ viewController: @escaping () -> ViewControllerType) -> some Request {
        request { ViewControllerWrapper(viewController: viewController()) }
    }
    
    @inlinable public func request<ViewControllerType: UIViewController>(_ viewController: ViewControllerType) -> some Request {
        request { viewController }
    }
    
    @inlinable public func request<ViewType: UIView>(_ view: @escaping () -> ViewType) -> some Request {
        request { ViewWrapper(view: view()) }
    }
    
    @inlinable public func request<ViewType: UIView>(_ view: ViewType) -> some Request {
        request { view }
    }
    
    public func request(_ route: String) -> some Request {
        request(matchable: route)
    }
    
    public func request(_ url: URL) -> some Request {
        request(matchable: url)
    }
    
    func request(matchable: Matchable) -> some Request {
        RouteRequest(navigation: self, configuration: Configuration(), uri: matchable.uri)
    }
}

// MARK: Static

extension Navigation {
    public static func register<T: Routable>(_ routableType: T.Type) {
        Routing.Router.instance.register(routableType: routableType)
    }
}
