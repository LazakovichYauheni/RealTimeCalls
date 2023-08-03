import UIKit

final class AddUserViewController: UIViewController {
    public let contentView = AddUserView()
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init() {
        contentView.configure(
            with: AddUserView.ViewModel(
                image: UIImage(named: "glasses") ?? UIImage(),
                textFieldViewModel: FloatingTextFieldView.ViewModel(
                    textField: FloatingTextField.ViewModel(title: "Username", id: "0"),
                    isInvalidInput: false,
                    isNeedToShowClearButton: true
                )
            )
        )
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
}
