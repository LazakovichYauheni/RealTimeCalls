//
//  Spacer.swift
//  WaveForm
//
//  Created by Doctor Kocte on 21.07.23.
//

import Foundation
import UIKit

/// Протокол для основных числовых констант для верстки и определяющий правила по которому верстаются визуальные компоненты
public protocol Spacer {}

/// Содержит основные базовые числовые константы
public extension Spacer {
    var zero: CGFloat { .zero }
    var pixel: CGFloat { 1 / UIScreen.main.nativeScale }
    var space05: CGFloat { 0.5 }
    var space1: CGFloat { 1 }
    var space2: CGFloat { 2 }
    var space4: CGFloat { 4 }
    var space6: CGFloat { 6 }
    var space8: CGFloat { 8 }
    var space10: CGFloat { 10 }
    var space12: CGFloat { 12 }
    var space16: CGFloat { 16 }
    var space20: CGFloat { 20 }
    var space24: CGFloat { 24 }
    var space28: CGFloat { 28 }
    var space30: CGFloat { 30 }
    var space32: CGFloat { 32 }
    var space36: CGFloat { 36 }
    var space40: CGFloat { 40 }
    var space42: CGFloat { 42 }
    var space48: CGFloat { 48 }
    var space56: CGFloat { 56 }
    var space60: CGFloat { 60 }
    var space72: CGFloat { 72 }
}

/// Обертка для Spacer совместимых типов
public struct SpacerWrapper<Base>: Spacer {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

/// Протокол описывающий которому должны конформить совместимы с Spacer типами
public protocol SpacerCompatible: AnyObject {}

extension SpacerCompatible {
    /// Предоставляет namespace обертку для Spacer совместимых типов.
    public var spacer: SpacerWrapper<Self> { SpacerWrapper(self) }
}

extension UIView: SpacerCompatible {}
extension UIViewController: SpacerCompatible {}
extension CAShapeLayer: SpacerCompatible {}
