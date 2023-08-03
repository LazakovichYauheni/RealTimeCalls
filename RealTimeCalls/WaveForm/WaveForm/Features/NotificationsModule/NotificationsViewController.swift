import UIKit

final class NotificationsViewController: UIViewController {
    public let contentView = NotificationsView()
    public var currentCell: NotificationsTableViewCell?
    
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
    
    public init(viewModels: [NotificationsTableViewCell.ViewModel]) {
        contentView.configure(with: .init(tableViewModels: viewModels))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }
}


extension NotificationsViewController: NotificationsViewEventsRespondable {
    func didSelectCell(index: Int, cell: NotificationsTableViewCell) {
        currentCell = cell
    }
}
