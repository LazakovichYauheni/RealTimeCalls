//
//  MainScreenInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 23.06.23.
//

import Foundation
import UIKit

public final class UserDetailsScreenInteractor {
    private let presenter: UserDetailsScreenPresenter
    private let data: MainScreenCollectionViewCell.ViewModel
    private let service: UserServiceProtocol
    
    private var isFavoriteEnabled: Bool = false
    
    public init(
        presenter: UserDetailsScreenPresenter,
        data: MainScreenCollectionViewCell.ViewModel,
        service: UserServiceProtocol
    ) {
        self.presenter = presenter
        self.data = data
        self.service = service
    }
    
    private func addToFavorites() {
        service.addToFavorites(username: data.username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.isFavoriteEnabled = !isFavoriteEnabled
                self.presenter.present(
                    data: self.data,
                    isFavoriteEnabled: isFavoriteEnabled,
                    isEditMode: false,
                    isLoadingState: false,
                    needToUpdateMainActionsStack: true
                )
            case .failure:
                self.presenter.present(
                    data: self.data,
                    isFavoriteEnabled: isFavoriteEnabled,
                    isEditMode: false,
                    isLoadingState: false,
                    needToUpdateMainActionsStack: true
                )
            }
        }
    }
}

extension UserDetailsScreenInteractor {
    func obtainInitialState() {
        isFavoriteEnabled = data.isFavorite
        presenter.present(
            data: data,
            isFavoriteEnabled: data.isFavorite,
            isEditMode: false,
            isLoadingState: false,
            needToUpdateMainActionsStack: false
        )
    }
    
    func obtainSelectedCell(index: Int) {}
    
    func obtainMainAction(id: Int) {
        switch id {
        case 0:
            presenter.presentCallScreen(title: data.name + " " + data.lastName)
        case 1:
            print("videoCall")
        case 2:
            presenter.present(
                data: data,
                isFavoriteEnabled: !isFavoriteEnabled,
                isEditMode: false,
                isLoadingState: true,
                needToUpdateMainActionsStack: true
            )
            addToFavorites()
        default:
            return
        }
    }
    
    func obtainAdditionalAction(id: Int?) {
        guard let id = id else { return }
        switch id {
        case 0:
            presenter.presentBlockAlert()
        case 1:
            print("qr")
        case 2:
            presenter.present(
                data: data,
                isFavoriteEnabled: isFavoriteEnabled,
                isEditMode: true,
                isLoadingState: false,
                needToUpdateMainActionsStack: false
            )
        default:
            return
        }
    }
    
    func obtainOKButton(
        titleText: String,
        descriptionText: String,
        noticeText: String
    ) {
        let newData = MainScreenCollectionViewCell.ViewModel(
            username: data.username,
            name: titleText,
            lastName: descriptionText,
            infoMessage: noticeText,
            image: data.image,
            callImage: data.callImage,
            gradientColors: data.gradientColors,
            detailsBackgroundColor: data.detailsBackgroundColor,
            detailsButtonBackgroundColor: data.detailsButtonBackgroundColor,
            isFavorite: data.isFavorite
        )
        presenter.present(
            data: newData,
            isFavoriteEnabled: isFavoriteEnabled,
            isEditMode: false,
            isLoadingState: false,
            needToUpdateMainActionsStack: false
        )
    }
    
    func obtainBlock() {
        print("add to block list")
    }
}

