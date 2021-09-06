import UIKit

extension Navigator {
    func present(operation: Navigation.Operation, destination: DestinationType, viewController: DestinationType.ViewControllerType, embeddingViewController: UIViewController?) {
        DispatchQueue.main.async {
            let dataPassingCandidates: [Any?] =
                self.configuration.protections +
                    [
                        destination,
                        self.configuration.embeddable,
                        viewController,
                        embeddingViewController
            ]
            self.passData(self.configuration.dataPassingBlock, to: dataPassingCandidates)
            let destinationViewController = embeddingViewController ?? viewController
            let result = self.doOnNavigationSuccess(destination: destination, viewController: viewController)
            var transitioningDelegate = self.configuration.transitioningDelegateBlock?()
            let sourceViewController = self.configuration.sourceViewController
            
            let modalPresentationStyle = self.configuration.modalPresentationStyleBlock()
            let modalTransitionStyle = self.configuration.modalTransitionStyleBlock()
            
            destinationViewController.modalPresentationStyle = modalPresentationStyle
            destinationViewController.modalTransitionStyle = modalTransitionStyle
            if
                #available(iOS 13, *),
                let isModalInPresentationBlock = self.configuration.isModalInPresentationBlock
            {
                destinationViewController.isModalInPresentation = isModalInPresentationBlock()
            }
            
            func action() {
                destinationViewController.transitioningDelegate = transitioningDelegate
                
                if sourceViewController is AnyDataReceivable {
                    let dataManager = UIViewController.DataManager()
                    dataManager.blocks.addObjects(from: self.configuration.dataReturningBlocks)
                    sourceViewController.coreNavigationDataManager = dataManager
                }
                
                sourceViewController.present(destinationViewController, animated: self.configuration.isAnimatedBlock(), completion: {
                    self.resultCompletion(with: result, operation: operation)
                    transitioningDelegate = nil
                })
            }
            
            if let delayBlock = self.configuration.delayBlock {
                let timeInterval = delayBlock()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval, execute: action)
            } else {
                DispatchQueue.main.async(execute: action)
            }
        }
    }
}
