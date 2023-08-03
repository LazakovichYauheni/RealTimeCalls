import UIKit
import SnapKit

protocol AllContactsViewEventsRespondable: AnyObject {
    func didSelectCell(index: Int, cell: ContactTableViewCell)
}

struct DefaultAlertViewStyle: AlertViewStyle {
    static var titleColor: UIColor { .black }
    static var descriptionColor: UIColor { .gray }
    static var backgroundColor: UIColor { .white }
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
    
    private lazy var alertView = AlertView<SmallGreenFillerViewStyle, DefaultAlertViewStyle>()
    
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
        backgroundColor = UIColor(red: 235 / 255, green: 241 / 255, blue: 245 / 255, alpha: 1)
        addSubviews()
        makeConstraints()
    }

    private func addSubviews() {
        addSubview(tableView)
        addSubview(alertView)
    }

    private func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        alertView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(spacer.space32)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.bottom.greaterThanOrEqualToSuperview()
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
        alertView.configure(
            with: AlertView<SmallGreenFillerViewStyle, DefaultAlertViewStyle>.ViewModel(
                icon: Images.endCallImage,
                title: "Privet",
                description: "Drug",
                actions: [
                    AlertButtonModel(background: .blue, title: "Add"),
                    AlertButtonModel(background: .red, title: "Decline")
                ]
            )
        )
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
