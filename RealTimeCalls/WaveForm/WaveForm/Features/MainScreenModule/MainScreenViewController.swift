//
//  LoginViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation
import UIKit
import FloatingPanel

public final class MainScreenViewController: UIViewController {
    
    private(set) var currentCell: MainScreenCollectionViewCell?
    
    private let interactor: MainScreenInteractor
    private(set) var contentView = MainScreenView(frame: .zero)
    
    private var viewModels: [MainScreenCollectionViewCell.ViewModel] = []
    private let presenter = TransitionPresenter()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.size.equalTo(spacer.space24)
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationTapped)))
        imageView.image = Images.addImage.withTintColor(Color.current.text.lightBlueColor)
        
        let item = UIBarButtonItem(customView: imageView)
        return item
    }()

    
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
        title = "Welcome"
        navigationItem.setRightBarButton(notificationButton, animated: false)
        navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: true)
        setNavigationBarTint(
            with: UIViewController.NavigationBarConfiguration(
                tintColor: Color.current.background.blackColor,
                barTintColor: Color.current.background.mainColor,
                textColor: Color.current.text.blackColor,
                isTranslucent: true,
                backgroundImage: UIImage(),
                shadowImage: UIImage()
            ),
            coordinatedTransition: false
        )
    }
    
    public init(interactor: MainScreenInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    @objc private func notificationTapped() {
        let notificationViewController = NotificationsViewController(viewModels: [
            NotificationsTableViewCell.ViewModel(alertViewModel: AlertView<SmallGreenFillerViewStyle, DefaultAlertViewStyle>.ViewModel(
                icon: UIImage(named: "call") ?? UIImage(),
                title: "Ty",
                description: "Pidor",
                actions: []
            )),
            NotificationsTableViewCell.ViewModel(alertViewModel: AlertView<SmallGreenFillerViewStyle, DefaultAlertViewStyle>.ViewModel(
                icon: UIImage(named: "call") ?? UIImage(),
                title: "Ty",
                description: "Pidor",
                actions: []
            ))
        ])
        

        let floatingController = FloatingPanelController()
        let surfaceAppearance = SurfaceAppearance()
        let layout = CustomFloatingLayout(targetGuide: notificationViewController.view.safeAreaLayoutGuide)
        surfaceAppearance.backgroundColor = .clear
        surfaceAppearance.shadows = []
        surfaceAppearance.cornerRadius = 16
        floatingController.surfaceView.grabberHandleSize = .zero
        floatingController.surfaceView.appearance = surfaceAppearance
        floatingController.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        floatingController.layout = layout
        
        floatingController.set(contentViewController: notificationViewController)
        navigationController?.present(floatingController, animated: true)
    }
}

extension MainScreenViewController {
    func display(viewModel: MainScreenView.ViewModel) {
        viewModels = viewModel.cellViewModels
        contentView.configure(viewModel: viewModel)
    }
    
    func displayAllContactsScreen(contacts: [Contact]) {
        let viewController = AllContactsAssemby().assemble(contacts: contacts)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainScreenViewController: MainScreenViewEventsRespondable {
    func didItemTapped(index: Int, cell: MainScreenCollectionViewCell) {
        guard let cellData = viewModels[safe: index] else { return }
        currentCell = cell
        
        presenter.present(cellData, from: self, duration: 0.35)
    }
    
    func didAllContactsTapped() {
        interactor.obtainAllContacts()
    }
}


class CustomFloatingLayout: FloatingPanelLayout {
    public let position: FloatingPanelPosition = .top
    public let initialState: FloatingPanelState = .full

    private unowned var targetGuide: UILayoutGuide

    public init(targetGuide: UILayoutGuide) {
        self.targetGuide = targetGuide
    }

    public var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        [
            .full: FloatingPanelAdaptiveLayoutAnchor(
                absoluteOffset: .zero,
                contentLayout: targetGuide,
                referenceGuide: .safeArea,
                contentBoundingGuide: .safeArea
            )
        ]
    }
    
    public func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.7
    }
    
    func prepareLayout(surfaceView: UIView, in view: UIView) -> [NSLayoutConstraint] {
        return [
            surfaceView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor),
            surfaceView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
    }
}
