import UIKit

public extension UIImage {
    /// Метод создает вью по указанному цвету и скруглению
    static func make(with color: UIColor, cornerRadius: CGFloat? = nil) -> UIImage? {
        let edge = cornerRadius.flatMap { $0 * 2 + 1 } ?? 1
        let size = CGSize(width: edge, height: edge)
        let rect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, .zero)
        let context = UIGraphicsGetCurrentContext()
        color.setFill()
        context?.fillEllipse(in: rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return cornerRadius.flatMap {
            image.resizableImage(withCapInsets: UIEdgeInsets(top: $0, left: $0, bottom: $0, right: $0))
        } ?? image
    }
}
