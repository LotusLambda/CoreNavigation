import Quick
import Nimble

import CoreNavigation

class TestPushViewController: QuickSpec {
    private class MockViewController: UIViewController, DataReceivable {
        typealias DataType = String
        
        var receivedData: String?
        
        func didReceiveData(_ data: String) {
            receivedData = data
        }
    }
    
    let canvas = Utilities.TestingCanvas(rootViewController: UINavigationController(rootViewController: UIViewController()))
    private let viewController = MockViewController()
    let passingData = "mock-data"
    
    override func spec() {
        describe("When presenting") {
            context("UIViewController instance", {
                Push { $0
                    .to(self.viewController, from: self.canvas.rootViewController)
                }
                
                it("is pushed", closure: {
                    expect(self.viewController.isViewLoaded).toEventually(beTrue())
                    expect(self.viewController.navigationController).toEventuallyNot(beNil())
                })
            })
        }
    }
}
