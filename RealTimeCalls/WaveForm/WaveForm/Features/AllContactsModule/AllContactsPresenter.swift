import UIKit

public final class AllContactsPresenter {
    weak var viewController: AllContactsViewController?
    
    private func makeViewModels(contacts: [Contact]) -> [ContactTableViewCell.ViewModel] {
        contacts.compactMap { contact in
            let image = Converter.convertBase64StringToImage(imageBase64String: contact.imageString)
            return ContactTableViewCell.ViewModel(
                image: image ?? UIImage.make(with: .black, cornerRadius: 16) ?? UIImage(),
                title: contact.firstName ?? .empty,
                description: contact.lastName ?? .empty
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
