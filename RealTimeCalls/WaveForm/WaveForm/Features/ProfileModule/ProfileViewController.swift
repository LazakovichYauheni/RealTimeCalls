import Foundation
import UIKit

public final class ProfileViewController: UIViewController {
    
    private let interactor: ProfileInteractor
    private let contentView = ProfileView(frame: .zero)
    private let imagePicker = UIImagePickerController()
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.obtainInitialState()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationBarTint(
            with: UIViewController.NavigationBarConfiguration(
                tintColor: Color.current.background.blackColor,
                barTintColor: Color.current.background.mainColor,
                textColor: Color.current.text.blackColor,
                isTranslucent: false,
                backgroundImage: UIImage(),
                shadowImage: UIImage()
            ),
            coordinatedTransition: false
        )
    }
    
    public init(interactor: ProfileInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
}

extension ProfileViewController {
    func display(viewModel: ProfileView.ViewModel) {
        contentView.configure(viewModel: viewModel)
    }
    
    func displayImageChoosing() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        navigationController?.present(imagePicker, animated: true)
    }
}

// MARK: - ProfileViewEventsRespondable

extension ProfileViewController: ProfileViewEventsRespondable {
    public func iconTapped() {
        interactor.obtainIconChanging()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        interactor.changeImage(image: image)
    }
}

extension ProfileViewController: ProfileActionViewEventsRespondable {
    func viewTapped(id: Int) {
        interactor.obtainAction(id: id)
    }
}
