//
//  LocalVideoView.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 15.04.23.
//

import UIKit
import SnapKit

public protocol LocalVideoViewEventsRespondable: AnyObject {
    func cancelButtonTapped()
    func startButtonTapped()
    func frontCameraSelected()
    func backCameraSelected()
}

final class LocalVideoView: UIView {

    private lazy var responder = Weak(firstResponder(of: LocalVideoViewEventsRespondable.self))
    private let titles: [String] = ["FRONT CAMERA", "BACK CAMERA"]
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start Video", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var cameraPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.transform = CGAffineTransform(rotationAngle: -CGFloat(90) * (CGFloat.pi / CGFloat(180)))
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(videoView: UIView) {
        addSubview(videoView)
        addSubview(cameraPicker)
        addSubview(startButton)
        addSubview(closeButton)
        videoView.clipsToBounds = true
        videoView.layer.cornerRadius = 16
        videoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(60)
            make.height.equalTo(60)
        }
        
        cameraPicker.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.snp.width)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        cameraPicker.subviews[1].backgroundColor = .clear
    }
    
    func showButtons() {
        startButton.isHidden = false
        closeButton.isHidden = false
        cameraPicker.isHidden = false
    }
    
    @objc private func closeTapped() {
        responder.object?.cancelButtonTapped()
    }
    
    @objc private func startTapped() {
        startButton.isHidden = true
        closeButton.isHidden = true
        cameraPicker.isHidden = true
        responder.object?.startButtonTapped()
    }
}

extension LocalVideoView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedTitle = titles[row]
        if selectedTitle == "FRONT CAMERA" {
            responder.object?.frontCameraSelected()
        } else if selectedTitle == "BACK CAMERA" {
            responder.object?.backCameraSelected()
        }
    }
}

extension LocalVideoView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerRow = UIView()
        pickerRow.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        let rowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        rowLabel.font = Fonts.Medium.medium15
        rowLabel.textColor = .white
        rowLabel.text = titles[row]
        rowLabel.textAlignment = .center
        pickerRow.addSubview(rowLabel)
        pickerRow.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        return pickerRow
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        160
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        100
    }
}
