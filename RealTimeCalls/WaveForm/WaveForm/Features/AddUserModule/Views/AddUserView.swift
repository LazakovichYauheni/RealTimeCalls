import UIKit
import SnapKit

protocol AddUserViewEventsRespondable {
    func sendKeyboardHeight(height: CGFloat)
    func didTapCell(id: Int)
}

/// View для заполнения иконок с фоном
public final class AddUserView: UIView {
    // MARK: - Subview Properties

    // MARK: - Private Properties
    
    private lazy var iconImageView = UIImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.Regular.regular16
        label.text = "To add a new contact, just write \nit’s username in a field below"
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private lazy var textField: FloatingTextFieldView = {
        let field = FloatingTextFieldView()
        field.clipsToBounds = true
        field.layer.cornerRadius = 12
        field.backgroundColor = .white
        return field
    }()

    private(set) lazy var contactsTableView: ResizableTableView = {
        let table = ResizableTableView()
        table.delegate = self
        table.register(ContactCell.self, forCellReuseIdentifier: "contactsCell")
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.backgroundColor = .clear
        return table
    }()
    
    private var keyboardHeight: CGFloat = .zero
    private var contactViewModels: [ContactCell.ViewModel] = []
    private lazy var responder = Weak(firstResponder(of: AddUserViewEventsRespondable.self))

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
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped))
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(gestureRecognizer)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func updateHeight() {
        responder.object?.sendKeyboardHeight(
            height: keyboardHeight + contactsTableView.contentSize.height
        )
    }

    private func addSubviews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(contactsTableView)
    }

    private func makeConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
        }
        
        contactsTableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(48)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            self.keyboardHeight = keyboardHeight
            updateHeight()
        }
    }
    
    @objc private func keyboardWillHide() {
        self.keyboardHeight = .zero
        updateHeight()
    }
    
    @objc private func viewDidTapped(sender: UITapGestureRecognizer) {
        endEditing(true)
    }
}

// MARK: - Configurable

extension AddUserView {
    public struct ViewModel {
        let image: UIImage
        let textFieldViewModel: FloatingTextFieldView.ViewModel
        let contactViewModels: [ContactCell.ViewModel]
        let isInitialState: Bool
    }

    public func configure(with viewModel: ViewModel) {
        iconImageView.image = viewModel.image
        textField.configure(with: viewModel.textFieldViewModel)
        contactViewModels = viewModel.contactViewModels
        contactsTableView.reloadData()
    }
}

extension AddUserView: UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AddUserView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactViewModels.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as? ContactCell,
            let viewModel = contactViewModels[safe: indexPath.row]
        else { return UITableViewCell() }
        cell.configure(viewModel: viewModel)
        return cell
    }
}

extension AddUserView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        responder.object?.didTapCell(id: indexPath.row)
    }
}
