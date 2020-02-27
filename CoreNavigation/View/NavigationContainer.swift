import SwiftUI

public struct NavigationContainer<Content> : View where Content : View {
    @ObservedObject var navigation: Navigation
    
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.navigation = Navigation(currentView: content())
    }
    
    public var body: some View {
        GeometryReader { (proxy) in
            ZStack {
                if self.navigation.direction == .forward {
                    self.navigation.previousView?
                        .environmentObject(self.navigation)
                        .zIndex(0)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .background(Color.white)
                        .disabled(true)
                    self.navigation.currentView
                        .environmentObject(self.navigation)
                        .zIndex(1)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .background(Color.white)
                        .shadow(color: Color.black.opacity(0.15), radius: 30, x: 0, y: 0)
                        .disabled(false)
                } else if self.navigation.direction == .backward {
                    self.navigation.currentView
                        .environmentObject(self.navigation)
                        .zIndex(0)
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .background(Color.white)
                        .disabled(false)
                } else {
                    self.navigation.currentView
                        .environmentObject(self.navigation)
                        .background(Color.white)
                        .disabled(false)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(self.navigation)
    }
}
