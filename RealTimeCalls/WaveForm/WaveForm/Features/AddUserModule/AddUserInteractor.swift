//
//  AddUserInteractor.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 4.08.23.
//

import Foundation

public final class AddUserInteractor {
    private lazy var requestManager = RequestManager()
    private lazy var endpointConfig = EndpointConfig()
    private lazy var service = UserService(requestManager: requestManager, endpointConfig: endpointConfig)
    private let presenter: AddUserPresenter

    private let throttler = CallDebouncer(delay: 0.8)
    
    private var isLoaderNeeded = false
    private var isSuccessNeeded = false
    private var text = ""
    
    private var contacts: [User] = []
    private var selectedContact: User?
    
    public init(presenter: AddUserPresenter) {
        self.presenter = presenter
    }
    
    func obtain() {
        presenter.presentInitialState()
    }
    
    func obtainBeginEditing(text: String, id: String) {
        
    }
    
    func textChanging(text: String) {
        self.text = text
        if text.isEmpty {
            presenter.present(
                text: text,
                isSuccessButtonNeeded: isSuccessNeeded,
                isLoaderNeeded: isLoaderNeeded,
                contacts: []
            )
        } else {
            throttler.flush()
            throttler.cancelCurrentJob()
            isSuccessNeeded = false
            isLoaderNeeded = true
            throttler.throttle { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.presenter.present(
                        text: self.text,
                        isSuccessButtonNeeded: false,
                        isLoaderNeeded: true,
                        contacts: []
                    )
                    self.checkUser(text: self.text)
                }
            }
        }
    }
    
    private func checkUser(text: String) {
        service.checkUser(username: text) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(users):
                if !users.searchedUsers.isEmpty {
                    self.contacts = users.searchedUsers
                    self.isSuccessNeeded = true
                    self.isLoaderNeeded = false
                    self.presenter.present(
                        text: self.text,
                        isSuccessButtonNeeded: true,
                        isLoaderNeeded: false,
                        contacts: users.searchedUsers.compactMap { $0.username }
                    )
                } else {
                    self.presenter.present(
                        text: self.text,
                        isSuccessButtonNeeded: false,
                        isLoaderNeeded: false,
                        contacts: []
                    )
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func obtainTextChanging(text: String, id: String) {
       textChanging(text: text)
    }
    
    func obtainClearButton() {
        throttler.flush()
        throttler.cancelCurrentJob()
        text = ""
        presenter.present(text: text, isSuccessButtonNeeded: false, isLoaderNeeded: false, contacts: [])
    }
    
    func obtainSuccess() {
        guard let selectedContact = selectedContact else {
            presenter.present(text: text, isSuccessButtonNeeded: false, isLoaderNeeded: false, contacts: [])
            return
        }
        service.addContact(username: selectedContact.username) { [weak self] result in
            switch result {
            case let .success(notification):
                self?.presenter.presentSuccessAlert(string: notification)
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func obtainSelectedContact(id: Int) {
        guard let contact = contacts[safe: id] else { return }
        selectedContact = contact
        self.text = contact.username
        presenter.present(text: text, isSuccessButtonNeeded: true, isLoaderNeeded: false, contacts: [])
    }
}
