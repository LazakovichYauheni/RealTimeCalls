//
//  LoginViewController.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 12.06.23.
//

import Foundation
import UIKit
import NotificationBannerSwift

public final class MainScreenViewController: UIViewController {
    
    private(set) var currentCell: MainScreenCollectionViewCell?
    
    private let interactor: MainScreenInteractor
    private(set) var contentView = MainScreenView(frame: .zero)
    
    private var viewModels: [MainScreenCollectionViewCell.ViewModel] = []
    private let presenter = TransitionPresenter()
    
    private lazy var notificationButton: UIBarButtonItem = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationTapped)))
        imageView.image = UIImage(named: "alert")?.withTintColor(UIColor(red: 0 / 255, green: 143 / 255, blue: 219 / 255, alpha: 1))
        
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
    
    public init(interactor: MainScreenInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
    
    @objc private func notificationTapped() {
        
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
