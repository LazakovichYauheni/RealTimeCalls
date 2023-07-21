import UIKit

final class AllContactsViewController: UIViewController {
    public let contentView = AllContactsView()
    public var currentCell: ContactTableViewCell?
    
    private let interactor: AllContactsInteractor
    private let transitionPresenter = TransitionPresenter()
    
    private lazy var addUserButton: UIBarButtonItem = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUser)))
        imageView.image = UIImage(named: "add")?.withTintColor(UIColor(red: 0 / 255, green: 143 / 255, blue: 219 / 255, alpha: 1))
        
        let item = UIBarButtonItem(customView: imageView)
        return item
    }()
    
    public override func loadView() {
        super.loadView()
        view = contentView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor.obtainInitialState()
        title = "All Contacts"
        navigationItem.setRightBarButton(addUserButton, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationBarTint(
            with: UIViewController.NavigationBarConfiguration(
                tintColor: .black,
                barTintColor: UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1),
                textColor: .black,
                isTranslucent: true,
                backgroundImage: UIImage(),
                shadowImage: UIImage()
            ),
            coordinatedTransition: false
        )
    }
    
    public init(interactor: AllContactsInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    @objc private func addUser() {
        
    }
}

extension AllContactsViewController {
    func display(viewModel: AllContactsView.ViewModel) {
        contentView.configure(with: viewModel)
    }
    
    func displayContactDetails(contact: Contact) {
        transitionPresenter.present(
            .init(
                name: contact.username ?? "",
                lastName: contact.username ?? "",
                infoMessage: contact.username ?? "",
                image: UIImage(named: "girl") ?? UIImage(),
                callImage: UIImage(named: "call") ?? UIImage(),
                isNeedToShowBorder: false,
                backgroundColor: UIColor(hue: 0.5, saturation: 0.44, brightness: 0.76, alpha: 1),
                buttonBackground: UIColor(hue: 0.5, saturation: 0.44, brightness: 0.59, alpha: 1)
            ),
            from: self,
            duration: 0.2
        )
    }
}


extension AllContactsViewController: AllContactsViewEventsRespondable {
    func didSelectCell(index: Int, cell: ContactTableViewCell) {
        currentCell = cell
        interactor.obtainSelectedCell(index: index)
    }
}
