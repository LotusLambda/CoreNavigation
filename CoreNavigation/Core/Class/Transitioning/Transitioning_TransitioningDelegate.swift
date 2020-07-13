extension Transitioning {
    class Delegate<FromViewControllerType: UIViewController, ToViewControllerType: UIViewController>: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
        let transitionDuration: TimeInterval
        let presentationControllerClass: UIPresentationController.Type?
        let transitionAnimation: (Transitioning.Context<FromViewControllerType, ToViewControllerType>) -> Void
        
        var fromViewController: FromViewControllerType?
        var toViewController: ToViewControllerType?
        var presentingViewController: UIViewController?
        var dismissedViewController: UIViewController?

        init(transitionDuration: TimeInterval, presentationControllerClass: UIPresentationController.Type?, transitionAnimation: @escaping (Transitioning.Context<FromViewControllerType, ToViewControllerType>) -> Void) {
            self.transitionDuration = transitionDuration
            self.presentationControllerClass = presentationControllerClass
            self.transitionAnimation = transitionAnimation
            super.init()
        }

        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            guard
                let fromViewController = source as? FromViewControllerType,
                let toViewController = presented as? ToViewControllerType
                else {
                    return nil
            }

            self.fromViewController = fromViewController
            self.toViewController = toViewController
            self.presentingViewController = presenting

            return self
        }

        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            self.dismissedViewController = dismissed
            
            return self
        }

        func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
            transitionDuration
        }

        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            guard
                let toViewController = toViewController,
                let presentingViewController = presentingViewController,
                let fromViewController = fromViewController
                else {
                    transitionContext.completeTransition(false)
                    return
            }

            let context = Transitioning.Context<FromViewControllerType, ToViewControllerType>(
                fromViewController: fromViewController,
                toViewController: toViewController,
                presentingViewController: presentingViewController,
                transitionContext: transitionContext,
                duration: transitionDuration(using: transitionContext)
            )

            transitionAnimation(context)
        }
        
        func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
            if let presentationControllerClass = self.presentationControllerClass {
                return presentationControllerClass.init(presentedViewController: presented, presenting: presenting)
            }
            
            return nil
        }
    }

}
