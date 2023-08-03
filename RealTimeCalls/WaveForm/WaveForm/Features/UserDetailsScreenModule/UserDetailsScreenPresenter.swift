import UIKit

public final class UserDetailsScreenPresenter {
    weak var viewController: UserDetailsScreenViewController?
    
    private func makeActionViewModels(backgroudColor: UIColor) -> [UserDetailsActionView.ViewModel] {
        let callViewModel = UserDetailsActionView.ViewModel(
            image: Images.statusEndImage,
            buttonTitle: "Call",
            imageBackgroundColor: backgroudColor
        )
        let historyViewModel = UserDetailsActionView.ViewModel(
            image: Images.statusEndImage,
            buttonTitle: "History",
            imageBackgroundColor: backgroudColor
        )
        let blockViewModel = UserDetailsActionView.ViewModel(
            image: Images.statusEndImage,
            buttonTitle: "Block",
            imageBackgroundColor: backgroudColor
        )
        
        return [callViewModel, historyViewModel, blockViewModel]
    }
}

extension UserDetailsScreenPresenter {
    func present(data: MainScreenCollectionViewCell.ViewModel) {
        viewController?.display(
            viewModel: UserDetailsScreenView.ViewModel(
                iconImage: data.image,
                name: data.name,
                lastName: data.lastName,
                backgroundColor: data.backgroundColor,
                actionButtonViewModels: makeActionViewModels(backgroudColor: data.buttonBackground)
            )
        )
    }
}
