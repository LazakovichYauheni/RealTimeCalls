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
                                    Color.current.background.dangerColor
                                ) ?? UIImage()
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: UIImage(named: "qr")?.withTintColor(data.buttonBackground) ?? UIImage()
                            ),
                            ImageFillerView<SmallWhiteFillerViewStyle>.ViewModel(
                                image: UIImage(named: "edit")?.withTintColor(data.buttonBackground) ?? UIImage()
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
