import UIKit
import FloatingPanel

final class AllContactsViewController: UIViewController {
    public let contentView = AllContactsView()
    public var currentCell: ContactTableViewCell?
    
    private let interactor: AllContactsInteractor
    private let transitionPresenter = TransitionPresenter()
    
    private lazy var addUserButton: UIBarButtonItem = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addUser)))
        imageView.image = Images.addImage.withTintColor(UIColor(red: 0 / 255, green: 143 / 255, blue: 219 / 255, alpha: 1))
        
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
        let addUserViewController = AddUserAssembly().assemble()
        
        let floatingController = AddContactFloatingController()
        let surfaceAppearance = SurfaceAppearance()
        let layout = FloatingLayout()
        surfaceAppearance.backgroundColor = UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1)
        surfaceAppearance.shadows = []
        surfaceAppearance.cornerRadius = 16
        floatingController.surfaceView.appearance = surfaceAppearance
        floatingController.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingController.layout = layout
        
        addUserViewController.setObserver(floatingController)
        
        floatingController.set(contentViewController: addUserViewController)
        navigationController?.present(floatingController, animated: true)
    }
}

extension AllContactsViewController {
    func display(viewModel: AllContactsView.ViewModel) {
        contentView.configure(with: viewModel)
    }
    
    func displayContactDetails(contact: Contact) {
        transitionPresenter.present(
            .init(
                name: contact.firstName,
                lastName: contact.firstName,
                infoMessage: contact.firstName,
                image: Images.girlImage,
                callImage:Images.girlImage,
                gradientColors: [],
                detailsBackgroundColor: .black,
                detailsButtonBackgroundColor: .white
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

protocol FloatingObservable {
    func updateHeight(height: CGFloat)
    func track(scrollView: UIScrollView)
}

class AddContactFloatingController: FloatingPanelController, FloatingObservable {
    func updateHeight(height: CGFloat) {
        let panelLayout = FloatingLayout()
        panelLayout.updateState(height: height)
        layout = panelLayout
        UIView.animate(withDuration: 0.3) {
            self.invalidateLayout()
        }
    }
    
    func trackScroll(scrollView: UIScrollView) {
        track(scrollView: scrollView)
    }
}

class FloatingLayout: FloatingPanelLayout {
    public var position: FloatingPanelPosition = .bottom
    public var initialState: FloatingPanelState = .full
    
    func updateState(height: CGFloat) {
        anchors[.full] = FloatingPanelLayoutAnchor(absoluteInset: height, edge: .bottom, referenceGuide: .superview)
    }

    var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelIntrinsicLayoutAnchor(absoluteOffset: .zero)
    ]
    
    public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.7
    }
}
