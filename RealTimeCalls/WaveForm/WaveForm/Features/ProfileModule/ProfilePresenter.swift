import Foundation
import UIKit

public final class ProfilePresenter {
    weak var viewController: ProfileViewController?
    
    private func makeActions() -> [ProfileActionView.ViewModel] {
        let editViewModel = ProfileActionView.ViewModel(
            id: .zero,
            icon: Images.editImage.withTintColor(Color.current.background.whiteColor),
            title: "Edit"
        )
        let blockedUsersViewModel = ProfileActionView.ViewModel(
            id: 1,
            icon: Images.blockImage.withTintColor(Color.current.background.whiteColor),
            title: "Blocked users"
        )
        let favoritesViewModel = ProfileActionView.ViewModel(
            id: 2,
            icon: Images.starImage.withTintColor(Color.current.background.whiteColor),
            title: "Favorites"
        )
        let muteViewModel = ProfileActionView.ViewModel(
            id: 3,
            icon: Images.muteImage.withTintColor(Color.current.background.whiteColor),
            title: "Mute for calls"
        )
        let themeViewModel = ProfileActionView.ViewModel(
            id: 4,
            icon: Images.magicWand.withTintColor(Color.current.background.whiteColor),
            title: "Change theme"
        )
        let logoutViewModel = ProfileActionView.ViewModel(
            id: 5,
            icon: Images.exit.withTintColor(Color.current.background.whiteColor),
            title: "Logout"
        )
        
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
                iconImage: image,
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
