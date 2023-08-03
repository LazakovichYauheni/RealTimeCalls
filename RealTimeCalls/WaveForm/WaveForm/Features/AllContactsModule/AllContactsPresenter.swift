import UIKit

public final class AllContactsPresenter {
    weak var viewController: AllContactsViewController?
    
    private func makeViewModels(contacts: [Contact]) -> [ContactTableViewCell.ViewModel] {
        contacts.compactMap { contact in
            ContactTableViewCell.ViewModel(
                image: UIImage(named: "girl") ?? UIImage(),
                title: contact.username ?? "",
                description: contact.username ?? ""
            )
        }
    }
}

extension AllContactsPresenter {
    func present(contacts: [Contact]) {
        viewController?.display(
            viewModel: AllContactsView.ViewModel(tableViewModels: makeViewModels(contacts: contacts))
        )
    }
    
    func presentSelectedCell(contact: Contact) {
        viewController?.displayContactDetails(contact: contact)
    }
}
