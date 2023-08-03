import UIKit
import SnapKit

protocol NotificationsViewEventsRespondable: AnyObject {
    func didSelectCell(index: Int, cell: NotificationsTableViewCell)
}

/// View для заполнения иконок с фоном
public final class NotificationsView: UIView {
    // MARK: - Subview Properties
    
    private lazy var tableView: ResizableTableView = {
        let table = ResizableTableView()
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "alertCell")
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        return table
    }()

    // MARK: - Private Properties
    
    private lazy var responder = Weak(firstResponder(of: NotificationsViewEventsRespondable.self))
    private var tableViewModels: [NotificationsTableViewCell.ViewModel] = []

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
        backgroundColor = .clear
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(tableView)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension NotificationsView {
    public struct ViewModel {
        let tableViewModels: [NotificationsTableViewCell.ViewModel]
    }

    public func configure(with viewModel: ViewModel) {
        tableViewModels = viewModel.tableViewModels
    }
}

// MARK: - UITableViewDelegate

extension NotificationsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NotificationsTableViewCell else { return }
        responder.object?.didSelectCell(index: indexPath.row, cell: cell)
    }
}

// MARK: - UITableViewDataSource

extension NotificationsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as? NotificationsTableViewCell,
            let viewModel = tableViewModels[safe: indexPath.row]
        else { return UITableViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}
