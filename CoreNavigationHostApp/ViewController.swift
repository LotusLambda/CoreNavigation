import UIKit
import CoreNavigation

class MyVC: UIViewController {
    lazy var close = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.stop, target: self, action: #selector(closeVC))
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
        navigationItem.setRightBarButton(close, animated: true)
    }
}

class OtherVC: MyVC, DataReceivable {
    func didReceiveData(_ data: String) {
        print("Data!", data)
    }
    
    typealias ParametersType = String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.view.backgroundColor = .green
        }
    }
}

struct MyRoute: Route {
    typealias Destination = OtherVC
    
    init() {}
    
    func route(handler: RouteHandler<MyRoute>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            handler.complete(data: "hello")
        }
    }
}

class MyLifetime: Lifetime {
    func cacheIdentifier() -> String {
        return "my"
    }
    
    func die(_ kill: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            kill()
        }
    }
    
    
}

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            Navigation
            .present { $0
                .to(MyRoute())
                .animated(false)
                .pass("Hello!")
                .embedInNavigationController()
                .on(.viewController(.viewDidAppear({ (viewController, animated) in
                    print("View controller!", viewController)
                })))
                .event.viewController(.viewWillDisappear({ (viewController, animated) in
                    print("Will disappear!")
                }))
                .keepAlive(within: MyLifetime())
            }
            
        }
                    /*
         
         
                .push { $0
                    .to(MyVC())
                    .animated(true)
                }
                .push { $0
                    .to(MyVC())
                    .animated(true)
                }
                .push { $0
                    .to(OtherVC())
                    .animated(true)
                    .pass(1)
                }
                .present { $0
                    .to(OtherVC())
                    .embedInNavigationController()
                    .animated(true)
                    .pass(2)
                }
                .push { $0
                    .to(MyRoute())
                    .animated(true)
                    .pass("Hello 2!")
                    .completion({
                        print("Completed!")
                    })
                     */
    }
}
