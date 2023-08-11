//
//  BaseAnimatedView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.08.23.
//

import UIKit

public final class BaseAnimatedView: UIView {
    private lazy var fadeTransion: CATransition = {
        let transition = CATransition()
        transition.duration = TimeInterval(0.3)
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        return transition
    }()

    private let contentView: UIView
    private var loadingView: UIView?
    
    private var tempView = UIView()
    private var currentView: UIView?
    private var workItem: DispatchWorkItem?
    
    public init(loadingView: UIView?, contentView: UIView) {
        self.loadingView = loadingView
        self.contentView = contentView
        super.init(frame: .zero)

        addSubview(tempView)
        tempView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        if let loadingView = loadingView {
            tempView.addSubview(loadingView)
            loadingView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            currentView = loadingView
        } else {
            tempView.addSubview(contentView)
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            currentView = contentView
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        currentView?.layoutSubviews()
    }
    
    func showLoading() {
        guard let loadingView = loadingView else { return }
        showView(view: loadingView)
    }
    
    func showContent() {
        guard currentView != contentView else { return }
        showView(view: contentView)
    }
    
    private func showView(view: UIView) {
        self.workItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard
                let self = self,
                view != currentView
            else { return }
            tempView.addSubview(view)
            layer.add(fadeTransion, forKey: nil)
            currentView?.removeFromSuperview()
            currentView = nil
            view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
                make.size.equalToSuperview()
            }
            currentView = view
        }
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: workItem)
        self.workItem = workItem
    }
}
