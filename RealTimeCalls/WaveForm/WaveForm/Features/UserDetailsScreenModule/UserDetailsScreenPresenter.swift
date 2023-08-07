import UIKit

public final class UserDetailsScreenPresenter {
    weak var viewController: UserDetailsScreenViewController?
}

extension UserDetailsScreenPresenter {
    func present(data: MainScreenCollectionViewCell.ViewModel) {
        viewController?.display(
            viewModel: UserDetailsScreenView.ViewModel(
                headerViewModel: UserDetailsHeaderView.ViewModel(
                    userImage: data.image,
                    mainActions: [
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            image: Images.statusEndImage
                        ),
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            image: Images.videoImage
                        ),
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            image: Images.maskStarImage
                        )
                    ],
                    additionalActionsViewModel: UserActionsView.ViewModel(
                        viewModels: [
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: Images.blockImage.withTintColor(Color.current.background.dangerColor)
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: Images.qrImage.withTintColor(data.buttonBackground)
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: Images.editImagee.withTintColor(data.buttonBackground)
                            )
                        ],
                        closeButtonBackground: data.buttonBackground
                    ),
                    actionsBackground: data.buttonBackground
                ),
                contentViewModel: UserDetailsContentView.ViewModel(
                    background: data.backgroundColor,
                    buttonBackground: data.buttonBackground,
                    title: data.name,
                    description: data.lastName,
                    notice: data.infoMessage
                )
            )
        )
    }
}
