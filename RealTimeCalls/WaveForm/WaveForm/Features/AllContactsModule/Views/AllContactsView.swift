import UIKit
import SnapKit

protocol AllContactsViewEventsRespondable: AnyObject {
    func didSelectCell(index: Int, cell: ContactTableViewCell)
}

struct DefaultAlertViewStyle: AlertViewStyle {
    static var titleColor: UIColor { Color.current.text.blackColor }
    static var descriptionColor: UIColor { Color.current.text.secondaryColor }
    static var backgroundColor: UIColor { Color.current.background.whiteColor }
}

/// View для заполнения иконок с фоном
public final class AllContactsView: UIView {
    // MARK: - Subview Properties
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: "contactsCell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        return table
    }()
    
    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.noContactsImage
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Private Properties
    
    private lazy var responder = Weak(firstResponder(of: AllContactsViewEventsRespondable.self))
    private var tableViewModels: [ContactTableViewCell.ViewModel] = []

    // MARK: - UIView

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func commonInit() {
        backgroundColor = Color.current.background.mainColor
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(tableView)
        addSubview(emptyImageView)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(150)
        }
    }
}

// MARK: - Configurable

extension AllContactsView {
    public struct ViewModel {
        let tableViewModels: [ContactTableViewCell.ViewModel]
    }

    public func configure(with viewModel: ViewModel) {
        tableViewModels = viewModel.tableViewModels
        if viewModel.tableViewModels.isEmpty {
            tableView.isHidden = true
            emptyImageView.isHidden = false
        }
    }
}

// MARK: - UITableViewDelegate

extension AllContactsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ContactTableViewCell else { return }
        responder.object?.didSelectCell(index: indexPath.row, cell: cell)
    }
}

// MARK: - UITableViewDataSource

extension AllContactsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as? ContactTableViewCell,
            let viewModel = tableViewModels[safe: indexPath.row]
        else { return UITableViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}
