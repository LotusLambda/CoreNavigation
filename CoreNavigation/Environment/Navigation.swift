import SwiftUI
import Combine

class Stack {
    struct Item {
        let view: AnyView
        let configuration: Configuration?
    }
    
    var items: [Item] = []
    var sheets: [SheetModifier.ViewModel] = []

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

    var currentSheet: SheetModifier.ViewModel
    
    @Published private(set) var direction: Direction?
    private(set) var currentView: AnyView
    private(set) var previousView: AnyView?
    
    init<ViewType: View>(currentView: ViewType) {
        let currentSheet = SheetModifier.ViewModel()
        self.currentSheet = currentSheet
        self.currentView = AnyView(currentView.modifier(SheetModifier(viewModel: currentSheet)))
    }

    public func push<ViewType: View>(view: ViewType) {
        push(view: view, configuration: nil)
    }
    
    func push<ViewType: View>(view: ViewType, configuration: Configuration?) {
        let view = build(view, with: configuration)
        
        stack.push(view: currentView, configuration: configuration)
        
        previousView = currentView
        
        currentView = AnyView(view)
        
        withAnimation(configuration?.animation) {
            direction = .forward
        }
    }
    
    public func sheet<ViewType: View>(view: ViewType) {
        sheet(view: view, configuration: nil)
    }
    
    func sheet<ViewType: View>(view: ViewType, configuration: Configuration?) {
        let view = build(view, with: configuration)
        
        let sheetViewModel = currentSheet
        stack.sheets.append(sheetViewModel)
        
        let newViewModel = SheetModifier.ViewModel()
        currentSheet = newViewModel

        sheetViewModel.content = AnyView(view
            .modifier(SheetModifier(viewModel: newViewModel))
            .environmentObject(self)
        )
        sheetViewModel.isPresented = true
    }
    
    public func pop() {
        guard let last = stack.pop() else { return }
        
        previousView = stack.items.last?.view
        
        currentView = last.view
        
        withAnimation(last.configuration?.animation) {
            direction = .backward
        }
    }
    
    public func dismiss() {
        guard let viewModel = self.stack.sheets.last else { return }

        dismiss(viewModel: viewModel)
    }
    
    func dismiss(viewModel: SheetModifier.ViewModel) {
        if self.currentSheet === viewModel {
            return
        }
        
        self.stack.sheets.removeAll { (element) -> Bool in
            element === viewModel
        }
        
        self.currentSheet = viewModel
        viewModel.isPresented = false
    }
    
    private func build<ViewType: View>(_ view: ViewType, with configuration: Configuration?) -> some View {
        var view = AnyView(view)
        if let transition = configuration?.transition {
            view = AnyView(view.transition(transition))
        }
        
        return view.environmentObject(self)
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
