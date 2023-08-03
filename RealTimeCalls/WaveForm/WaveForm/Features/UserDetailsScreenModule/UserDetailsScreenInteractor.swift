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
    
    public init(
        presenter: UserDetailsScreenPresenter,
        data: MainScreenCollectionViewCell.ViewModel
    ) {
        self.presenter = presenter
        self.data = data
    }
}

extension UserDetailsScreenInteractor {
    func obtainInitialState() {
        presenter.present(data: data)
    }
    
    func obtainSelectedCell(index: Int) {}
}

