//
//  MainScreenPresenter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 23.06.23.
//

import UIKit

public final class MainScreenPresenter {
    weak var viewController: MainScreenViewController?
    
    private func makeViewModels(contacts: [Contact]) -> [MainScreenCollectionViewCell.ViewModel] {
        return contacts.compactMap { contact in
            let randomValue = CGFloat.random(in: (0...1))
            return MainScreenCollectionViewCell.ViewModel(
                name: contact.firstName,
                lastName: "Cell",
                infoMessage: "loh",
                image: Images.girlImage,
                callImage: Images.statusEndImage,
                isNeedToShowBorder: false,
                backgroundColor: UIColor(hue: randomValue, saturation: 0.44, brightness: 0.76, alpha: 1),
                buttonBackground: UIColor(hue: randomValue, saturation: 0.44, brightness: 0.59, alpha: 1)
            )
        }
    }
}

extension MainScreenPresenter {
    func present(user: User) {
        viewController?.display(
            viewModel: MainScreenView.ViewModel(
                cellViewModels: makeViewModels(contacts: user.contacts),
                firstRecentContactViewModel: MainScreenContactView.ViewModel(name: "Emma"),
                secondRecentContactViewModel: MainScreenContactView.ViewModel(name: "Emma")
            )
        )
    }
    
    func presentAll(contacts: [Contact]) {
        viewController?.displayAllContactsScreen(contacts: contacts)
    }
}
