import Foundation
import UIKit

public final class ProfileInteractor {
    
    private let presenter: ProfilePresenter
    private let user: User
    private let service: UserServiceProtocol
    
    public init(user: User, presenter: ProfilePresenter, service: UserServiceProtocol) {
        self.user = user
        self.presenter = presenter
        self.service = service
    }
}

extension ProfileInteractor {
    func obtainInitialState() {
        presenter.presentInitialState(user: user)
    }
    
    func obtainIconChanging() {
        presenter.presentChooseImageFromGallery()
    }
    
    func changeImage(image: UIImage) {
        let string = Converter.convertImageToBase64String(img: image)
        service.changeProfileImage(string: string) { [weak self] result in
            switch result {
            case .success:
                print("success")
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func obtainAction(id: Int) {
        switch id {
        case 0:
            presenter.presentEditProfile()
        case 1:
            return
        case 2:
            return
        case 3:
            return
        case 4:
            return
        case 5:
            NotificationCenter.default.post(name: Notification.Name("Unauthorized"), object: nil)
        default:
            return
        }
    }
}
