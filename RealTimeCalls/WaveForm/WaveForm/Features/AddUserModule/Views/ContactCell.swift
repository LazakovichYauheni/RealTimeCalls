//
//  ContactView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 8.08.23.
//

import Foundation
import UIKit

final class ContactCell: UITableViewCell {
    // MARK: - UIView
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = Fonts.Medium.medium14
        label.textColor = .black
        label.isUserInteractionEnabled = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var title: String = .empty
    
    private func commonInit() {
        backgroundColor = .clear
        selectionStyle = .none
        isMultipleTouchEnabled = false
        contentView.addSubview(containerView)
        containerView.addSubview(label)

        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

extension ContactCell {
    struct ViewModel {
        let text: String
    }
    
    func configure(viewModel: ViewModel) {
        title = viewModel.text
        label.text = viewModel.text
    }
}
