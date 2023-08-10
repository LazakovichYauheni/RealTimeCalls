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
                            image: UIImage(named: "call") ?? UIImage()
                        ),
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            image: UIImage(named: "video") ?? UIImage()
                        ),
                        ImageFillerView<DefaultLargeFillerViewStyle>.ViewModel(
                            image: UIImage(named: "maskStar") ?? UIImage()
                        )
                    ],
                    additionalActionsViewModel: UserActionsView.ViewModel(
                        viewModels: [
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: UIImage(named: "block")?.withTintColor(
                                    UIColor(red: 191 / 255, green: 88 / 255, blue: 88 / 255, alpha: 1)
                                ) ?? UIImage()
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: UIImage(named: "qr")?.withTintColor(data.detailsButtonBackgroundColor) ?? UIImage()
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: UIImage(named: "edit")?.withTintColor(data.detailsButtonBackgroundColor) ?? UIImage()
                            )
                        ],
                        closeButtonBackground: data.detailsButtonBackgroundColor
                    ),
                    actionsBackground: data.detailsButtonBackgroundColor
                ),
                contentViewModel: UserDetailsContentView.ViewModel(
                    background: data.detailsBackgroundColor,
                    buttonBackground: data.detailsButtonBackgroundColor,
                    title: data.name,
                    description: data.lastName,
                    notice: data.infoMessage
                )
            )
        )
    }
}
