//
//  UIViewController+Extensions.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import UIKit

extension UIViewController {
    public struct NavigationBarConfiguration {
        /// Отвечает за цвет элементов внутри NavigationBar
        public let tintColor: UIColor?
        /// Отвечает за цвет бэкграунда  внутри NavigationBar
        public let barTintColor: UIColor?
        /// Цвет текста элементов внутри NavigationBar
        public let textColor: UIColor?
        /// Прозрачный ли NavigationBar, влияет на фрейм view, если false, то view
        /// будет начинаться от NavigationBar, а safeArea = 0, в ином случае
        /// view будет лежать под navigationBar
        public let isTranslucent: Bool
        /// Применять если хотите чтобы в бэкграунде была картинка, не анимируемое проперти
        /// Если хотите установить цвет, то используйте barTintColor
        public let backgroundImage: UIImage?
        /// Картинка для тени внизу NavigationBar
        public let shadowImage: UIImage?
        /// Картанка для кнопки назад
        public let backButtonImage: UIImage
        /// Картинка для маски кнопки назад во время перехода
        public let backButtonTransitionMaskImage: UIImage?

        public init(
            tintColor: UIColor?,
            barTintColor: UIColor?,
            textColor: UIColor?,
            isTranslucent: Bool,
            backgroundImage: UIImage?,
            shadowImage: UIImage?,
            backButtonImage: UIImage = UIImage(),
            backButtonTransitionMaskImage: UIImage? = nil
        ) {
            self.tintColor = tintColor
            self.barTintColor = barTintColor
            self.textColor = textColor
            self.isTranslucent = isTranslucent
            self.backgroundImage = backgroundImage
            self.shadowImage = shadowImage
            self.backButtonImage = backButtonImage
            self.backButtonTransitionMaskImage = backButtonTransitionMaskImage
        }
    }

    public func setNavigationBarTint(
        with configuration: NavigationBarConfiguration,
        coordinatedTransition: Bool = true
    ) {
        let tintBlock = {
            guard let navigationBar = self.navigationController?.navigationBar else { return }

            navigationBar.isTranslucent = configuration.isTranslucent
            navigationBar.barTintColor = configuration.barTintColor
            navigationBar.tintColor = configuration.tintColor
            let appearance = UINavigationBarAppearance()
            if configuration.isTranslucent {
                appearance.configureWithTransparentBackground()
            } else {
                appearance.configureWithOpaqueBackground()
            }
            appearance.shadowColor = .clear
            appearance.backgroundColor = configuration.barTintColor
            appearance.backgroundImage = configuration.backgroundImage
            appearance.shadowImage = configuration.shadowImage
            appearance.titleTextAttributes[.foregroundColor] = configuration.textColor ?? .white
            appearance.largeTitleTextAttributes[.foregroundColor] = configuration.textColor ?? .white

            appearance.setBackIndicatorImage(
                configuration.backButtonImage,
                transitionMaskImage: configuration.backButtonTransitionMaskImage
            )
            
            if #available(iOS 15.0, *) {
                navigationBar.compactScrollEdgeAppearance = appearance
            } else {
                let backgroundImage = configuration.isTranslucent
                    ? (configuration.backgroundImage ?? UIImage())
                    : configuration.backgroundImage
                let shadowImage = configuration.isTranslucent
                    ? (configuration.shadowImage ?? UIImage())
                    : configuration.shadowImage
                navigationBar.setBackgroundImage(backgroundImage, for: .default)
                navigationBar.shadowImage = shadowImage
                navigationBar.backIndicatorImage = configuration.backButtonImage
                navigationBar.backIndicatorTransitionMaskImage = configuration.backButtonTransitionMaskImage
                if let textColor = configuration.textColor {
                    navigationBar.titleTextAttributes?[.foregroundColor] = textColor
                }
            }
            navigationBar.standardAppearance = appearance
            navigationBar.compactAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance

            self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        }
        if coordinatedTransition {
            transitionCoordinator?.animate(
                alongsideTransition: { _ in tintBlock() },
                completion: nil
            )
        } else {
            tintBlock()
        }
    }
}
