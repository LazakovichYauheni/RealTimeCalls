//
//  UIResponder+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.03.23.
//

import UIKit

public extension UIResponder {
    /// Первый респондер в responder chain реализующий данный протокол
    func firstResponder<T>(of type: T.Type) -> T? {
        if let responder = self as? T {
            return responder
        } else {
            guard let next = next else { return nil }
            return next.firstResponder(of: type)
        }
    }
}

public struct Weak<Object> {
    typealias ObjectProvider = () -> Object?
    public var object: Object? { provider?() }
    private let provider: ObjectProvider?

    public init(_ object: Object?) {
        let reference = object as AnyObject

        provider = { [weak reference] in
            reference as? Object
        }
    }
}
