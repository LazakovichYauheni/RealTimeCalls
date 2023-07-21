import UIKit

// MARK: - Constants

private enum Constants {
    static let scaleMultiplyer: CGFloat = 20
    static let alphaMultiplyer: CGFloat = 10
    static let velocityThresholdPerPage: CGFloat = 2
    static let numberOfItemsPerPage: CGFloat = 1
    static let positiveNextPage: CGFloat = 1
    static let negativeNextPage: CGFloat = -1
    static let scaleXMaxConstant: CGFloat = 1
    static let alphaMaxConstant: CGFloat = 1
    static let halfDelimiter: CGFloat = 2
}

/// Лейаут для коллекшна, в котором реализована smooth пагинация
final class PagingCollectionViewLayout: UICollectionViewFlowLayout {
    public var isScalingEnabled = true
    public var isFadeEnabled = true

    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }

        let pageLength: CGFloat
        let approxPage: CGFloat
        let currentPage: CGFloat
        let speed: CGFloat

        if scrollDirection == .horizontal {
            pageLength = (itemSize.width + minimumLineSpacing) * Constants.numberOfItemsPerPage
            approxPage = collectionView.contentOffset.x / pageLength
            speed = velocity.x
        } else {
            pageLength = (itemSize.height + minimumLineSpacing) * Constants.numberOfItemsPerPage
            approxPage = collectionView.contentOffset.y / pageLength
            speed = velocity.y
        }

        if speed < .zero {
            currentPage = ceil(approxPage)
        } else if speed > .zero {
            currentPage = floor(approxPage)
        } else {
            currentPage = round(approxPage)
        }

        guard speed != .zero else {
            if scrollDirection == .horizontal {
                return CGPoint(x: currentPage * pageLength, y: .zero)
            } else {
                return CGPoint(x: .zero, y: currentPage * pageLength)
            }
        }

        var nextPage: CGFloat = currentPage + (speed > .zero ? Constants.positiveNextPage : Constants.negativeNextPage)

        let increment = speed / Constants.velocityThresholdPerPage
        nextPage += (speed < .zero) ? ceil(increment) : floor(increment)

        if scrollDirection == .horizontal {
            return CGPoint(x: nextPage * pageLength, y: .zero)
        } else {
            return CGPoint(x: .zero, y: nextPage * pageLength)
        }
    }

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        return attributes?.compactMap { attribute in
            guard attribute.representedElementCategory == .cell else { return attribute }
            return layoutAttributesForItem(at: attribute.indexPath)
        }
    }

    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard
            let collectionView = collectionView,
            let attributes = super.layoutAttributesForItem(at: indexPath)
        else { return nil }
        let centerX = collectionView.contentOffset.x + collectionView.frame.size.width / Constants.halfDelimiter
        let offsetX = abs(centerX - attributes.center.x)

        attributes.transform = .identity
        let offsetPercentage = offsetX / (collectionView.bounds.width * Constants.scaleMultiplyer)
        let alphaPercentage = offsetX / (collectionView.bounds.width * Constants.alphaMultiplyer)
        let alpha = Constants.alphaMaxConstant - alphaPercentage
        let scaleX = Constants.scaleXMaxConstant - offsetPercentage
        if isScalingEnabled {
            attributes.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
        }
        if isFadeEnabled {
            attributes.alpha = alpha
        }
        return attributes
    }

    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }
}
