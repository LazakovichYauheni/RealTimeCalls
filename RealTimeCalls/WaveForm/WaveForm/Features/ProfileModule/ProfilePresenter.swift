import Foundation
import UIKit

public final class ProfilePresenter {
    weak var viewController: ProfileViewController?
    
    private func makeActions() -> [ProfileActionView.ViewModel] {
        let editViewModel = ProfileActionView.ViewModel(id: .zero, icon: Images.editImage, title: "Edit")
        let blockedUsersViewModel = ProfileActionView.ViewModel(id: 1, icon: Images.blockImage, title: "Blocked users")
        let favoritesViewModel = ProfileActionView.ViewModel(id: 2, icon: Images.starImage, title: "Favorites")
        let muteViewModel = ProfileActionView.ViewModel(id: 3, icon: Images.muteImage, title: "Mute for calls")
        let themeViewModel = ProfileActionView.ViewModel(id: 4, icon: Images.magicWand, title: "Change theme")
        let logoutViewModel = ProfileActionView.ViewModel(id: 5, icon: Images.exit, title: "Logout")
        
        return [
            editViewModel,
            blockedUsersViewModel,
            favoritesViewModel,
            muteViewModel,
            themeViewModel,
            logoutViewModel
        ]
    }
}

extension ProfilePresenter {
    func presentInitialState(user: User) {
        let image = Converter.convertBase64StringToImage(imageBase64String: user.imageString)
        viewController?.display(
            viewModel: .init(
                iconImage: image ?? UIImage(),
                title: (user.firstName ?? .empty) + " " + (user.lastName ?? .empty),
                username: user.username,
                actionViewModels: makeActions()
            )
        )
    }
    
    func presentChooseImageFromGallery() {
        viewController?.displayImageChoosing()
    }
    
    func presentEditProfile() {
        
    }
}
