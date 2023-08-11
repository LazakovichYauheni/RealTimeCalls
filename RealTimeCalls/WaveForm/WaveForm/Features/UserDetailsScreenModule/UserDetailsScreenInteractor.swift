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
    
    public init(
        presenter: UserDetailsScreenPresenter,
        data: MainScreenCollectionViewCell.ViewModel,
        service: UserServiceProtocol
    ) {
        self.presenter = presenter
        self.data = data
        self.service = service
    }
}

extension UserDetailsScreenInteractor {
    func obtainInitialState() {
        presenter.present(data: data, isFavoriteEnabled: false)
    }
    
    func obtainSelectedCell(index: Int) {}
    
    func obtainMainAction(id: Int) {
        switch id {
        case 0:
            print("call")
        case 1:
            print("videoCall")
        case 2:
            presenter.present(data: data, isFavoriteEnabled: true)
            service.addToFavorites(username: data.username) { [weak self] result in
                switch result {
                case .success:
                    return
                case .failure:
                    guard let self = self else { return }
                    self.presenter.present(data: self.data, isFavoriteEnabled: false)
                }
            }
        default:
            return
        }
    }
}

