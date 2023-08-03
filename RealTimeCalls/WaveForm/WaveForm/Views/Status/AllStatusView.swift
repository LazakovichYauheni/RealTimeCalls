//
//  AllStatusView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 14.03.23.
//

import UIKit

public final class AllStatusView: UIView {
    
    private var statusView: StatusProtocol = StatusView(text: .empty)
    
    public init(statusView: StatusView) {
        super.init(frame: .zero)
        self.statusView = statusView
        guard let statusView = self.statusView as? UIView else { return }
        addSubview(statusView)
        
        statusView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transition(view: StatusProtocol) {
        guard
            let view = view as? UIView,
            let statusView = self.statusView as? UIView
        else { return }
        let newView = view
        addSubview(newView)
        newView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
        }

        newView.transform = (CGAffineTransform(scaleX: 0.8, y: 0.1)).concatenating(CGAffineTransform(translationX: 0, y: 9))

        UIView.animate(withDuration: 0.2, delay: .zero, options: .curveLinear, animations: {
            newView.transform = .identity
            newView.alpha = 1
            statusView.alpha = 0
            statusView.transform = (CGAffineTransform(scaleX: 0.8, y: 0.1)).concatenating(
                CGAffineTransform(translationX: 0, y: -9)
            )
        }, completion: { _ in
            statusView.removeFromSuperview()
            guard let newView = newView as? StatusProtocol else { return }
            self.statusView = newView
            statusView.transform = .identity
        })
    }
}
