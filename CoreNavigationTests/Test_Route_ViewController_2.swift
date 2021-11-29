import Quick
import Nimble

import CoreNavigation

class TestRouteViewController2: QuickSpec {
    final class MockViewController: UIViewController, Routable {
        func didResolve(viewController: UIViewController) {
            
        }
        
        static func routePatterns() -> [String] {
            ["http://example.com/TestRouteViewController2/:parameter1/:parameter2"]
        }
        
        required init(parameters: [String : Any]?, uri: String, pattern: String) throws {
            self.parameters = parameters
            super.init(nibName: nil, bundle: nil)
        }
        
        let parameters: [String: Any]?
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
    }
    
    override func spec() {
        describe("When resolving UIViewController from") {
            context("route", {
                Register(MockViewController.self)
                let url = URL(string: "http://example.com/TestRouteViewController2/one/two?parameter3=three")
                
                let viewController = try? url?.viewController() as? MockViewController
                
                it("resolved view controller", closure: {
                    expect(viewController).toEventuallyNot(beNil())
                })
                
                it("extracted parameters", closure: {
                    let expectedParameters: NSDictionary = [
                        "parameter1": "one",
                        "parameter2": "two",
                        "parameter3": "three"
                    ]
                    
                    expect(viewController?.parameters as NSDictionary?).toEventually(equal(expectedParameters))
                })
            })
        }
    }
}
