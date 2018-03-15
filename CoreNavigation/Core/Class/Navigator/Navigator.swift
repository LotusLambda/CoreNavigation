import Foundation
import UIKit

class Navigator {
    static var queue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()

    static func navigate<T>(with type: NavigationType, configuration: Configuration<T>, completion: (() -> Void)? = nil) {
        let operation = NavigationOperation(block: { handler in
            switch configuration.destination {
            case .viewController(let viewController):
                switch type {
                case .push:
                    push(viewController, with: configuration, completion: {
                        handler()
                    })
                case .present:
                    present(viewController, with: configuration, completion: {
                        handler()
                    })
                }
            case .routePath(let routePath):
                ()
            case .viewControllerBlock(let block):
                block { viewController in
                    switch type {
                    case .push:
                        push(viewController, with: configuration, completion: {
                            handler()
                        })
                    case .present:
                        print("Executing operation block")

                        present(viewController, with: configuration, completion: {
                            handler()
                        })
                    }
                    
                }
            case .viewControllerClassBlock(let block):
                block { viewControllerClass in
                    let viewController = viewControllerClass.init(nibName: nil, bundle: nil)
                    
                    switch type {
                    case .push:
                        push(viewController, with: configuration, completion: {
                            handler()
                        })
                    case .present:
                        print("Executing operation block")
                        
                        present(viewController, with: configuration, completion: {
                            handler()
                        })
                    }
                    
                }
            case .unknown:
                ()
            }
            
            completion?()
        })
        print("Added operation")
        queue.addOperation(operation)
    }
    
    static func viewControllerToNavigate<T>(_ viewController: UIViewController, with configuration: Configuration<T>) -> UIViewController {
        guard let embeddingType = configuration.embedding.embeddingType else {
            return viewController
        }
        
        switch embeddingType {
        case .embeddingProtocol(let aProtocol):
            return aProtocol.embed(viewController)
        case .navigationController:
            return UINavigationController(rootViewController: viewController)
        }
    }
}
