//
//  RandomViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then
import SnapKit

final class RandomViewController: UIViewController {
    // MARK: - UI
    private let searchTextField = SearchTextField()
    private let randomButton = UIButton()
    private let shareButton = UIButton()
    private let gifImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
}

// MARK: - Attributes & Layout
extension RandomViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .cyan
        }
        
        searchTextField.do {
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        gifImageView.do {
            $0.backgroundColor = .red
        }
        
        randomButton.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .systemPink
            $0.setTitle("클릭!", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        }
        
        shareButton.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .systemBlue
            $0.setTitle("공유", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(searchTextField)
        
        self.view.addSubview(gifImageView)
        gifImageView.snp.makeConstraints {
            $0.width.height.equalTo(self.view.snp.width).dividedBy(2)
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view).multipliedBy(0.9)
        }
        
        searchTextField.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.bottom.equalTo(gifImageView.snp.top).offset(-constant)
            $0.width.equalTo(self.view).dividedBy(2)
            $0.centerX.equalTo(self.view)
            $0.height.equalTo(searchTextField.snp.width).dividedBy(5)
        }
        
        self.view.addSubview(randomButton)
        randomButton.snp.makeConstraints {
            $0.width.equalTo(searchTextField.snp.width)
            $0.height.equalTo(randomButton.snp.width).multipliedBy(0.15)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.bottom.equalTo(searchTextField.snp.top).offset(-10)
        }
        
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.width.equalTo(randomButton.snp.width)
            $0.height.equalTo(shareButton.snp.width).multipliedBy(0.15)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.bottom.equalTo(randomButton.snp.top).offset(-10)
        }
    }
}
