//
//  TimerView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 16.03.23.
//

import UIKit
import SnapKit

public final class TimerView: UIView {
    private lazy var label: UILabel = {
       let uiLabel = UILabel()
        uiLabel.textColor = .white
        uiLabel.textAlignment = .center
        uiLabel.font = Fonts.Regular.regular15
        return uiLabel
    }()
    
    private var seconds: Int = .zero
    
    private var timer = Timer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(fired),
            userInfo: nil,
            repeats: true
        )
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        label.text = timeString(time: TimeInterval(seconds))
    }
    
    deinit {
        timer.invalidate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc private func fired() {
        seconds += 1
        label.text = timeString(time: TimeInterval(seconds))
    }
    
    private func timeString(time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
