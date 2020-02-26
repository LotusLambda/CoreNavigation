import SwiftUI

public struct ViewWrapper<UIViewType: UIView>: UIViewRepresentable {
    let view: UIViewType
    
    public init(view: UIViewType) {
        self.view = view
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ViewWrapper<UIViewType>>) -> UIViewType {
        view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<ViewWrapper<UIViewType>>) {
        
    }
}
