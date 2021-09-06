import UIKit

extension Navigation.Builder.To.Present {
    @discardableResult public func modalPresentationStyle(_ block: @escaping () -> UIModalPresentationStyle) -> Self {
        queue.sync { configuration.modalPresentationStyleBlock = block }

        return self
    }

    @discardableResult public func modalPresentationStyle(_ modalPresentationStyle: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle { modalPresentationStyle }
    }
    
    @discardableResult public func isModalInPresentation(_ block: @escaping () -> Bool) -> Self {
        queue.sync { configuration.isModalInPresentationBlock = block }
        
        return self
    }
    
    @discardableResult public func isModalInPresentation(_ isModalInPresentation: Bool) -> Self {
        self.isModalInPresentation { isModalInPresentation }
    }
}
