//
//  ImageFillerViewStyles.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 2.08.23.
//

import UIKit

public protocol ImageFillerViewStyle {
    static var imageSize: CGSize { get }
    static var imageInsets: CGFloat { get }
    static var radius: CGFloat { get }
    static var backgroundColor: UIColor { get }
}

// SMALL

public struct SmallWithoutAlphaFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 4 }
    public static var radius: CGFloat { 16 }
    public static var backgroundColor: UIColor { .black }
}

public struct SmallGrayWithoutAlphaFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 4 }
    public static var radius: CGFloat { 16 }
    public static var backgroundColor: UIColor { UIColor(red: 216 / 255, green: 226 / 255, blue: 235 / 255, alpha: 1) }
}

public struct SmallFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 8 }
    public static var radius: CGFloat { 8 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}

public struct SmallGreenFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 8 }
    public static var radius: CGFloat { 8 }
    public static var backgroundColor: UIColor { .green.withAlphaComponent(0.2) }
}

public struct SmallWhiteFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 4 }
    public static var radius: CGFloat { 16 }
    public static var backgroundColor: UIColor { .white }
}

// DEFAULT

public struct DefaultFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 20, height: 20) }
    public static var imageInsets: CGFloat { 10 }
    public static var radius: CGFloat { 20 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}

public struct DefaultLargeFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 12 }
    public static var radius: CGFloat { 24 }
    public static var backgroundColor: UIColor { .white }
}

// MEDIUM

public struct MediumFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 32, height: 32) }
    public static var imageInsets: CGFloat { 10 }
    public static var radius: CGFloat { 26 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}

// LARGE

public struct LargeFillerViewStyle: ImageFillerViewStyle {
    public static var imageSize: CGSize { .init(width: 24, height: 24) }
    public static var imageInsets: CGFloat { 14 }
    public static var radius: CGFloat { 26 }
    public static var backgroundColor: UIColor { .white.withAlphaComponent(0.2) }
}
