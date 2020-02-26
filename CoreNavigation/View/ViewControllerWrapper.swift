import SwiftUI

public struct ViewControllerWrapper<UIViewControllerType: UIViewController>: UIViewControllerRepresentable {
    let viewController: UIViewControllerType
    
    public init(viewController: UIViewControllerType) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ViewControllerWrapper<UIViewControllerType>>) -> UIViewControllerType {
        viewController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<ViewControllerWrapper<UIViewControllerType>>) {
        
    }
}
