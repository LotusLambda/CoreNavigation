import SwiftUI

public struct NavigationContainer<Content> : View where Content : View {
    @ObservedObject var navigation: Navigation
    
    public init(navigation: Navigation) {
        self.navigation = navigation
    }
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.navigation = Navigation(rootView: content())
    }
    
    public var body: some View {
        GeometryReader { (proxy) in
            if self.navigation.direction == .forward {
//                                self.navigation.previousView?
//                                    .environmentObject(self.navigation)
//                                    .frame(width: proxy.size.width, height: proxy.size.height)
//                                    .disabled(true)
//                                    .zIndex(0)
                                self.navigation.currentView
                                    .environmentObject(self.navigation)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .disabled(false)
                                    .zIndex(1)
                            } else if self.navigation.direction == .backward {
                                self.navigation.currentView
                                    .environmentObject(self.navigation)
                                    .frame(width: proxy.size.width, height: proxy.size.height)
                                    .disabled(false)
                                    .zIndex(0)
                            } else {
                                self.navigation.currentView
                                    .environmentObject(self.navigation)
                                    .disabled(false)
                                    .zIndex(1)
                            }
        }
        .environmentObject(self.navigation)
    }
}
