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
        return contacts.enumerated().compactMap { index, contact in
            let randomValue = CGFloat.random(in: (0...1))
            let gradientFirstColors = [
                UIColor(red: 222 / 255, green: 131 / 255, blue: 245 / 255, alpha: 1),
                UIColor(red: 131 / 255, green: 245 / 255, blue: 231 / 255, alpha: 1),
                UIColor(red: 243 / 255, green: 206 / 255, blue: 109 / 255, alpha: 1),
                UIColor(red: 255 / 255, green: 95 / 255, blue: 229 / 255, alpha: 1),
                UIColor(red: 131 / 255, green: 245 / 255, blue: 142 / 255, alpha: 1)
            ]
            let gradientSecondColors = [
                UIColor(red: 69 / 255, green: 60 / 255, blue: 171 / 255, alpha: 1),
                UIColor(red: 69 / 255, green: 60 / 255, blue: 171 / 255, alpha: 1),
                UIColor(red: 155 / 255, green: 37 / 255, blue: 94 / 255, alpha: 1),
                UIColor(red: 46 / 255, green: 198 / 255, blue: 219 / 255, alpha: 1),
                UIColor(red: 60 / 255, green: 138 / 255, blue: 171 / 255, alpha: 1)
            ]
            
            let detailsBackgroundColors = [
                UIColor(red: 97 / 255, green: 49 / 255, blue: 175 / 255, alpha: 1),
                UIColor(red: 51 / 255, green: 94 / 255, blue: 163 / 255, alpha: 1),
                UIColor(red: 167 / 255, green: 70 / 255, blue: 75 / 255, alpha: 1),
                UIColor(red: 46 / 255, green: 113 / 255, blue: 176 / 255, alpha: 1),
                UIColor(red: 52 / 255, green: 155 / 255, blue: 136 / 255, alpha: 1)
            ]
            
            let detailsButtonBackgroundColors = [
                UIColor(red: 68 / 255, green: 35 / 255, blue: 121 / 255, alpha: 1),
                UIColor(red: 35 / 255, green: 76 / 255, blue: 141 / 255, alpha: 1),
                UIColor(red: 150 / 255, green: 49 / 255, blue: 55 / 255, alpha: 1),
                UIColor(red: 36 / 255, green: 83 / 255, blue: 126 / 255, alpha: 1),
                UIColor(red: 27 / 255, green: 121 / 255, blue: 104 / 255, alpha: 1)
            ]
            
            let firstColor = gradientFirstColors[index]
            let secondColor = gradientSecondColors[index]
            
            return MainScreenCollectionViewCell.ViewModel(
                name: contact.firstName,
                lastName: "Cell",
                infoMessage: "loh",
                image: Images.girlImage,
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
        let hardcodeContacts = [
            Contact(dto: ContactDTO(id: "0", firstName: "odin", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "1", firstName: "dva", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "2", firstName: "tri", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "3", firstName: "4tyre", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "4", firstName: "pyat", lastName: "odin", phoneNumber: "qwewq", isFavorite: true))
        ]
        viewController?.display(
            viewModel: MainScreenView.ViewModel(
                cellViewModels: makeViewModels(contacts: hardcodeContacts),
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
    
    func presentEmpty() {
//        viewController?.display(
//            viewModel: MainScreenView.ViewModel(
//                cellViewModels: [],
//                recentContactViewModels: []
//            )
//        )
        
        let hardcodeContacts = [
            Contact(dto: ContactDTO(id: "0", firstName: "odin", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "1", firstName: "dva", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "2", firstName: "tri", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "3", firstName: "4tyre", lastName: "odin", phoneNumber: "qwewq", isFavorite: true)),
            Contact(dto: ContactDTO(id: "4", firstName: "pyat", lastName: "odin", phoneNumber: "qwewq", isFavorite: true))
        ]
        viewController?.display(
            viewModel: MainScreenView.ViewModel(
                cellViewModels: makeViewModels(contacts: hardcodeContacts),
                recentContactViewModels: [
                    MainScreenContactView.ViewModel(name: "Emma"),
                    MainScreenContactView.ViewModel(name: "Emma")
                ]
            )
        )
    }
}
