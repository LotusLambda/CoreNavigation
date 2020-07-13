let operationQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    return queue
}()

class Navigator<DestinationType: Destination, FromType: UIViewController> {
    let queue: DispatchQueue
    let configuration: Configuration<DestinationType, FromType>
    
    let cache = Caching.Cache.instance

    init(queue: DispatchQueue, configuration: Configuration<DestinationType, FromType>) {
        initFramework

        self.queue = queue
        self.configuration = configuration
    }

    func navigate() -> Navigation.Operation {
        let operation = Navigation.Operation { (operation) in
            if let dependency = operation.dependencies.first as? Navigation.Operation {
                self.configuration.sourceViewController = dependency.presentedViewController as! FromType
            }
            
            self.protectNavigation(onAllow: {
                switch self.configuration.directive {
                case .direction(let navigationType):
                    switch navigationType {
                    case .forward(let forward):
                        self.resolve(
                            onComplete: { (destination, viewController, embeddingViewController) in
                                func present() {
                                    self.present(operation: operation, destination: destination, viewController: viewController, embeddingViewController: embeddingViewController)
                                }
                                func push() {
                                    self.push(operation: operation, destination: destination, viewController: viewController, embeddingViewController: embeddingViewController)
                                }
                                func childViewController() {
                                    self.childViewController(operation: operation, destination: destination, viewController: viewController, embeddingViewController: embeddingViewController)
                                }
                                
                                switch forward {
                                case .present: present()
                                case .push: push()
                                case .childViewController: childViewController()
                                case .automatic:
                                    DispatchQueue.main.async {
                                        if embeddingViewController?.isKind(of: UINavigationController.self) == true {
                                            present()
                                        } else if
                                            self.configuration.sourceViewController.navigationController != nil,
                                            !(viewController is UINavigationController)
                                        {
                                            push()
                                        } else {
                                            present()
                                        }
                                    }
                                }
                            },
                            onCancel: { error in
                                self.resultFailure(with: error, operation: operation)
                        })
                    case .back(let back):
                        switch back {
                        case .dismiss: self.dismiss(operation: operation)
                        case .pop: self.pop(operation: operation)
                        case .popToRootViewController: self.popToRootViewController(operation: operation)
                        case .automatic:
                            DispatchQueue.main.async {
                                if
                                    let navigationController = self.configuration.sourceViewController.navigationController,
                                    navigationController.viewControllers.count > 1
                                {
                                    self.pop(operation: operation)
                                } else {
                                    self.dismiss(operation: operation)
                                }
                            }
                        }
                    case .segue(let identifier): self.performSegue(with: identifier, operation: operation)
                    }
                case .none: break
                }
            }, onDisallow: { (error) in
                self.resultFailure(with: error, operation: operation)
            })
        }
        
        operationQueue.addOperation(operation)
        
        return operation
    }

    func doOnNavigationSuccess(
        destination: DestinationType,
        viewController: DestinationType.ViewControllerType) -> Navigation.Result<DestinationType, FromType> {
        let result = Navigation.Result<DestinationType, FromType>(destination: destination, toViewController: viewController, fromViewController: configuration.sourceViewController)

        configuration.onSuccessBlocks.forEach { $0(result) }

        return result
    }

    func resultFailure(with error: Error, operation: Navigation.Operation) {
        configuration.onFailureBlocks.forEach { $0(error) }
        operation.cancel()
    }

    func resultCompletion(with result: Navigation.Result<DestinationType, FromType>, operation: Navigation.Operation) {
        configuration.onCompletionBlocks.forEach { $0(result) }
        operation.presentedViewController = result.toViewController
        operation.finish()
    }

    func resolve(onComplete: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void, onCancel: @escaping (Error) -> Void) {
        let caching = configuration.cachingBlock?()
        let destination = configuration.destination

        func resolveNew() {
            resolve(
                destination,
                embeddable: configuration.embeddable,
                onComplete: { destination, viewController, embeddingViewController in
                    if let caching = caching {
                        self.cache(cacheIdentifier: caching.0, cacheable: caching.1, viewController: viewController, embeddingViewController: embeddingViewController)
                    }

                    self.configuration.viewControllerEventBlocks.forEach { self.bindEvents(to: viewController, navigationEvents: $0()) }
                    
                    if self.configuration.dataPassingBlock == nil {
                        self.prepareForStateRestorationIfNeeded(viewController: viewController, viewControllerData: nil)
                    }

                    onComplete(destination, viewController, embeddingViewController)
                    
                    destination.didResolve(viewController: viewController)
                },
                onCancel: onCancel
            )
        }

        if let caching = caching {
            resolveFromCache(destination, cacheIdentifier: caching.0, success: onComplete, failure: resolveNew)
        } else {
            resolveNew()
        }
    }

    func bindEvents<ViewControllerType: UIViewController>(to viewController: ViewControllerType, navigationEvents: [UIViewController.Event<ViewControllerType>]) {
        let viewControllerEvents = UIViewController.Observer()

        navigationEvents.forEach { (event) in
            switch event {
            case .loadView(let block):
                viewControllerEvents.onLoadView { block($0 as! ViewControllerType) }
            case .viewDidLoad(let block):
                viewControllerEvents.onViewDidLoad { block($0 as! ViewControllerType) }
            case .viewWillAppear(let block):
                viewControllerEvents.onViewWillAppear { block($0 as! ViewControllerType, $1) }
            case .viewDidAppear(let block):
                viewControllerEvents.onViewDidAppear { block($0 as! ViewControllerType, $1) }
            case .viewWillDisappear(let block):
                viewControllerEvents.onViewWillDisappear { block($0 as! ViewControllerType, $1) }
            case .viewDidDisappear(let block):
                viewControllerEvents.onViewDidDisappear { block($0 as! ViewControllerType, $1) }
            case .viewWillTransition(let block):
                viewControllerEvents.onViewWillTransition { block($0 as! ViewControllerType, $1, $2) }
            case .viewWillLayoutSubviews(let block):
                viewControllerEvents.onViewWillLayoutSubviews { block($0 as! ViewControllerType) }
            case .viewDidLayoutSubviews(let block):
                viewControllerEvents.onViewDidLayoutSubviews { block($0 as! ViewControllerType) }
            case .viewLayoutMarginsDidChange(let block):
                viewControllerEvents.onViewLayoutMarginsDidChange { block($0 as! ViewControllerType) }
            case .viewSafeAreaInsetsDidChange(let block):
                viewControllerEvents.onViewSafeAreaInsetsDidChange { block($0 as! ViewControllerType) }
            case .updateViewConstraints(let block):
                viewControllerEvents.onUpdateViewConstraints { block($0 as! ViewControllerType) }
            case .willMoveTo(let block):
                viewControllerEvents.onWillMoveTo { block($0 as! ViewControllerType, $1) }
            case .didMoveTo(let block):
                viewControllerEvents.onDidMoveTo { block($0 as! ViewControllerType, $1) }
            case .didReceiveMemoryWarning(let block):
                viewControllerEvents.onDidReceiveMemoryWarning { block($0 as! ViewControllerType) }
            case .applicationFinishedRestoringState(let block):
                viewControllerEvents.onApplicationFinishedRestoringState { block($0 as! ViewControllerType) }
            }
        }

        viewController.coreNavigationEvents = viewControllerEvents
    }

    private func resolve<DestinationType: Destination>(
        _ destination: DestinationType,
        embeddable: Embeddable?,
        onComplete: @escaping (DestinationType, DestinationType.ViewControllerType, UIViewController?) -> Void,
        onCancel: @escaping (Error) -> Void) {
        destination.resolve(
            with: Resolver<DestinationType>(
                onCompleteBlock: { viewController in
                    guard let embeddable = embeddable else {
                        onComplete(destination, viewController, nil)
                        return
                    }

                    do {
                        try embeddable.embed(
                            with: Embedding.Context(
                                rootViewController: viewController,
                                onComplete: { (embeddingViewController) in
                                    onComplete(destination, viewController, embeddingViewController)
                                },
                                onCancel: onCancel)
                        )
                    } catch let error {
                        onCancel(error)
                    }
                },
                onCancelBlock: onCancel
            )
        )
    }
}
