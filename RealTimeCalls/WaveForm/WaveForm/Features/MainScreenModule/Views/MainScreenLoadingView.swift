//
//  MainScreenLoadingView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 11.08.23.
//

import Foundation
import UIKit

private extension Spacer {
    var itemSize: CGSize { CGSize(width: 226, height: 326) }
}

final class MainScreenLoadingView: UIView {
    private lazy var titleLoadingView: LoadingView = {
        let view = LoadingView()
        view.layer.cornerRadius = spacer.space8
        return view
    }()
    
    private lazy var favoritesCardLoadingView: LoadingView = {
        let view = LoadingView()
        view.layer.cornerRadius = spacer.space24
        return view
    }()
    
    private lazy var secondTitleLoadingView: LoadingView = {
        let view = LoadingView()
        view.layer.cornerRadius = spacer.space8
        return view
    }()
    
    private lazy var firstRecentLoadingView: LoadingView = {
        let view = LoadingView()
        view.layer.cornerRadius = spacer.space16
        return view
    }()
    
    private lazy var secondRecentLoadingView: LoadingView = {
        let view = LoadingView()
        view.layer.cornerRadius = spacer.space16
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = Color.current.background.mainColor
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLoadingView)
        addSubview(favoritesCardLoadingView)
        addSubview(secondTitleLoadingView)
        addSubview(firstRecentLoadingView)
        addSubview(secondRecentLoadingView)
    }
    
    private func makeConstraints() {
        titleLoadingView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(spacer.space32)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.size.equalTo(CGSize(width: 240, height: 24))
        }
        
        favoritesCardLoadingView.snp.makeConstraints { make in
            make.top.equalTo(titleLoadingView.snp.bottom).offset(spacer.space24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(spacer.itemSize.height)
        }
        
        secondTitleLoadingView.snp.makeConstraints { make in
            make.top.equalTo(favoritesCardLoadingView.snp.bottom).offset(spacer.space24)
            make.leading.equalToSuperview().inset(spacer.space16)
            make.size.equalTo(CGSize(width: 240, height: 24))
        }
        
        firstRecentLoadingView.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLoadingView.snp.bottom).offset(spacer.space40)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.height.equalTo(100)
        }
        
        secondRecentLoadingView.snp.makeConstraints { make in
            make.top.equalTo(firstRecentLoadingView.snp.bottom).offset(spacer.space8)
            make.leading.trailing.equalToSuperview().inset(spacer.space16)
            make.bottom.lessThanOrEqualToSuperview()
            make.height.equalTo(100)
        }
    }
}
