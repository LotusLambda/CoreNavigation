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
    public func request<ViewType: View>(_ view: ViewType) -> some Request {
        ViewRequest(navigation: self, configuration: Configuration(), destination: AnyDestination(content: { AnyDestination.ViewType(view) }))
    }
    
    public func request<DestinationType: Destination>(_ destination: DestinationType) -> some Request {
        ViewRequest(navigation: self, configuration: Configuration(), destination: destination)
    }
    
    public func request(_ route: String) -> some Request {
        RouteRequest(navigation: self, configuration: Configuration(), route: route)
    }
    
    public func request(_ url: URL) -> some Request {
        RouteRequest(navigation: self, configuration: Configuration(), route: url)
    }
    
}
