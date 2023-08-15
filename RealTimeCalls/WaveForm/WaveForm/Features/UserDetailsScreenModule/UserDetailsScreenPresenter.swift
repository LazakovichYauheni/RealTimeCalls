import UIKit

public final class UserDetailsScreenPresenter {
    weak var viewController: UserDetailsScreenViewController?
}

extension UserDetailsScreenPresenter {
    func present(
        data: MainScreenCollectionViewCell.ViewModel,
        isFavoriteEnabled: Bool,
        isEditMode: Bool,
        isLoadingState: Bool,
        needToUpdateMainActionsStack: Bool
    ) {
        viewController?.display(
            viewModel: UserDetailsScreenView.ViewModel(
                headerViewModel: UserDetailsHeaderView.ViewModel(
                    userImage: data.image,
                    mainActions: [
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            id: .zero,
                            image: Images.statusEndImage
                        ),
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            id: 1,
                            image: Images.videoImage
                        ),
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            id: 2,
                            image: isFavoriteEnabled ? Images.maskStarImage : Images.starImage
                        )
                    ],
                    additionalActionsViewModel: UserActionsView.ViewModel(
                        viewModels: [
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                id: .zero,
                                image: Images.blockImage.withTintColor(Color.current.background.dangerColor)
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                id: 1,
                                image: Images.qrImage.withTintColor(data.detailsButtonBackgroundColor)
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                id: 2,
                                image: Images.editImage.withTintColor(data.detailsButtonBackgroundColor)
                            )
                        ],
                        closeButtonBackground: data.detailsButtonBackgroundColor
                    ),
                    actionsBackground: data.detailsButtonBackgroundColor,
                    needToUpdateMainActionsStack: needToUpdateMainActionsStack
                ),
                contentViewModel: UserDetailsContentView.ViewModel(
                    background: data.detailsBackgroundColor,
                    buttonBackground: data.detailsButtonBackgroundColor,
                    title: data.name,
                    description: data.lastName,
                    notice: data.infoMessage,
                    isEditMode: isEditMode,
                    isButtonAnimationNeeded: isLoadingState
                ),
                isEditMode: isEditMode
            )
        )
    }
    
    func presentBlockAlert() {
        viewController?.displayAlert(title: "Block user", message: "Do you really want to block this user?")
    }
    
    func presentCallScreen(title: String) {
        viewController?.displayCallScreen(title: title)
    }
}
