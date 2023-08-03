//
//  UserDetailsTableViewCell.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 18.07.23.
//

import UIKit

final class NotificationsTableViewCell: UITableViewCell {
    
    private lazy var alertView = AlertView<SmallGreenFillerViewStyle, DefaultAlertViewStyle>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(alertView)
    }
    
    private func makeConstraints() {
        alertView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension NotificationsTableViewCell {
    struct ViewModel {
        let alertViewModel: AlertView<SmallGreenFillerViewStyle, DefaultAlertViewStyle>.ViewModel
    }
    
    func configure(viewModel: ViewModel) {
        alertView.configure(with: viewModel.alertViewModel)
    }
}
