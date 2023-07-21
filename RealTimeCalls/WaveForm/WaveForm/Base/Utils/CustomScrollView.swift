import UIKit

public final class CustomScrollView: UIScrollView {
    // MARK: - Private Properties

    override public var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return super.intrinsicContentSize
    }
}
