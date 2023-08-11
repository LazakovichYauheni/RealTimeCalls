//
//  MainScreenPresenter.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 23.06.23.
//

import UIKit

public final class MainScreenPresenter {
    weak var viewController: MainScreenViewController?
    
    private func makeViewModels(contacts: [Contact], user: User) -> [MainScreenCollectionViewCell.ViewModel] {
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
                username: user.username,
                name: contact.firstName ?? .empty,
                lastName: contact.lastName ?? .empty,
                infoMessage: "loh",
                image: image ?? Images.girlImage,
                callImage: Images.statusEndImage,
                gradientColors: [firstColor, secondColor],
                detailsBackgroundColor: detailsBackgroundColors[index],
                detailsButtonBackgroundColor: detailsButtonBackgroundColors[index]
            )
        }
    }
}

extension MainScreenPresenter {
    func present(user: User) {
        viewController?.display(
            viewModel: MainScreenView.ViewModel(
                cellViewModels: makeViewModels(contacts: user.contacts, user: user),
                recentContactViewModels: [
                    MainScreenContactView.ViewModel(name: "Emma"),
                    MainScreenContactView.ViewModel(name: "Emma")
                ]
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
//        viewController?.display(
//            viewModel: MainScreenView.ViewModel(
//                cellViewModels: [],
//                recentContactViewModels: []
//            )
//        )
        
//        let hardcodeContacts = [
//            Contact(dto: ContactDTO(id: "0", firstName: "odin odin odin odin odin odin odin odin odin odin odin", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
//            Contact(dto: ContactDTO(id: "1", firstName: "dva", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
//            Contact(dto: ContactDTO(id: "2", firstName: "tri", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
//            Contact(dto: ContactDTO(id: "3", firstName: "4tyre", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
//            Contact(dto: ContactDTO(id: "4", firstName: "pyat", lastName: "odin", phoneNumber: "qwewq", isFavorite: true))
//        ]
//        viewController?.display(
//            viewModel: MainScreenView.ViewModel(
//                cellViewModels: makeViewModels(contacts: hardcodeContacts),
//                recentContactViewModels: [
//                    MainScreenContactView.ViewModel(name: "Emma"),
//                    MainScreenContactView.ViewModel(name: "Emma")
//                ]
//            )
//        )
    }
}
