import UIKit

extension UIViewController {

    /// Returns the current application's top most view controller.
    public static func visibleViewController<T: UIViewController>(in window: UIWindow = {
        if Thread.isMainThread {
            return UIApplication.shared.keyWindow
        } else {
            return DispatchQueue.main.sync { UIApplication.shared.keyWindow }
        }
    }() ?? {
        func window() -> UIWindow {
            let window = UIWindow()
            window.makeKeyAndVisible()
            return window
        }
        
        if Thread.isMainThread {
            return window()
        } else {
            return DispatchQueue.main.sync {
                return window()
            }
        }
    }()) -> T {
        func viewController() -> T {
            let rootViewController = window.rootViewController ?? {
                let viewController = UIViewController()
                window.rootViewController = viewController
                return viewController
            }()

            return self.visibleViewController(of: rootViewController)
        }
        
        if Thread.isMainThread {
            return viewController()
        } else {
            return DispatchQueue.main.sync {
                return viewController()
            }
        }
        
    }

    /// Returns the top most view controller from given view controller's stack.
    static func visibleViewController<T: UIViewController>(of viewController: UIViewController) -> T {
        // UITabBarController
        if
            let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController
        {
            return self.visibleViewController(of: selectedViewController)
        }

        // UINavigationController
        if
            let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController
        {
            return self.visibleViewController(of: visibleViewController)
        }

        // presented view controller
        if let presentedViewController = viewController.presentedViewController {
            return self.visibleViewController(of: presentedViewController)
        }

        // child view controller
        for subview in viewController.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.visibleViewController(of: childViewController)
            }
        }

        guard let viewController = viewController as? T else {
            fatalError()
        }

        return viewController
    }

}
