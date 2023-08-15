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
        let favoriteContacts = contacts.filter { $0.isFavorite }
        return favoriteContacts.enumerated().compactMap { index, contact in
            let gradientFirstColors = Color.current.background.gradientBackgroundFirstColors
            let gradientSecondColors = Color.current.background.gradientBackgroundSecondColors
            let detailsBackgroundColors = Color.current.background.detailsBackgroundColors
            let detailsButtonBackgroundColors = Color.current.background.detailsButtonBackgroundColors
            
            let firstColor = gradientFirstColors[index]
            let secondColor = gradientSecondColors[index]
            
            let image = Converter.convertBase64StringToImage(imageBase64String: contact.imageString)
            
            return MainScreenCollectionViewCell.ViewModel(
                username: contact.username,
                name: contact.firstName ?? .empty,
                lastName: contact.lastName ?? .empty,
                infoMessage: "loh",
                image: image ?? Images.girlImage,
                callImage: Images.statusEndImage,
                gradientColors: [firstColor, secondColor],
                detailsBackgroundColor: detailsBackgroundColors[index],
                detailsButtonBackgroundColor: detailsButtonBackgroundColors[index],
                isFavorite: true
            )
        }
    }
    
    private func makeRecents(recentContacts: [RecentContact]) -> [MainScreenContactView.ViewModel] {
        return recentContacts.compactMap { contact in
            let viewModel = MainScreenContactView.ViewModel(name: contact.contact.firstName ?? .empty)
            return viewModel
        }
    }
}

extension MainScreenPresenter {
    func present(user: User) {
        viewController?.display(
            viewModel: MainScreenView.ViewModel(
                cellViewModels: makeViewModels(contacts: user.contacts),
                recentContactViewModels: makeRecents(recentContacts: user.recentContacts)
            )
        )
    }
    
    func presentAll(contacts: [Contact]) {
        viewController?.displayAllContactsScreen(contacts: contacts)
    }
    
    func presentProfile(user: User) {
        viewController?.displayProfile(user: user)
    }
    
    func presentEmpty() {
        viewController?.display(
            viewModel: MainScreenView.ViewModel(
                cellViewModels: [],
                recentContactViewModels: []
            )
        )
    }
}
