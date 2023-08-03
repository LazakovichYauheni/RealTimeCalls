//
//  NetworkAnimatableView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit
import SnapKit

private extension Spacer {
    var space15: CGFloat { 15 }
}

public final class NetworkAnimatableView: UIView {
    private lazy var firstView = BaseNetworkView(layerHeight: 4)
    private lazy var secondView = BaseNetworkView(layerHeight: 7)
    private lazy var thirdView = BaseNetworkView(layerHeight: 11)
    private lazy var fourthView = BaseNetworkView(layerHeight: 15)
    
    private lazy var stackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = spacer.space2
        return stack
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped(completion: @escaping () -> Void) {
        fourthView.tapped {
            self.thirdView.tapped {
                self.secondView.tapped {
                    self.firstView.tapped() {
                        completion()
                    }
                }
            }
        }
    }
    
    private func addSubviews() {
        addSubview(stackView)
        stackView.addArrangedSubview(firstView)
        stackView.addArrangedSubview(secondView)
        stackView.addArrangedSubview(thirdView)
        stackView.addArrangedSubview(fourthView)
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints { make in
            make.height.equalTo(spacer.space15)
            make.edges.equalToSuperview()
        }
        
        firstView.snp.makeConstraints { make in
            make.width.equalTo(spacer.space4)
        }
        
        secondView.snp.makeConstraints { make in
            make.width.equalTo(spacer.space4)
        }
        
        thirdView.snp.makeConstraints { make in
            make.width.equalTo(spacer.space4)
        }
        
        fourthView.snp.makeConstraints { make in
            make.width.equalTo(spacer.space4)
        }
        
        stackView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
}
