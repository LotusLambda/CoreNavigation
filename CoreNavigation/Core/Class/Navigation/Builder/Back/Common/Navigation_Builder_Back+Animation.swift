import UIKit

extension Navigation.Builder.Back {
    @discardableResult public func animated(_ block: @escaping () -> Bool) -> Self {
        queue.sync { configuration.isAnimatedBlock = block }

        return self
    }

    @discardableResult public func animated(_ isAnimated: Bool) -> Self {
        animated { isAnimated }
    }
}
