//
//  RemoteVideoView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 15.04.23.
//

import UIKit
import SnapKit

final class RemoteVideoView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(videoView: UIView) {
        addSubview(videoView)
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
