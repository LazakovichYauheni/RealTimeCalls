//
//  TransitionDismisser.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 18.07.23.
//

import UIKit

final class TransitionDismisser {
    func dismiss(productViewController viewController: UIViewController) {
        viewController.presentingViewController?.dismiss(animated: true)
    }
}
