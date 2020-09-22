//
//  DetailViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then
import SnapKit

final class DetailViewController: UIViewController {
    private let giphyView = UIImageView()
    private let nameLabel = UILabel()
    private let closeButton = CloseButton()
    private let shareButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
}

extension DetailViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .blue
        }
        
        closeButton.do {
            $0.addTarget(self, action: #selector(close), for: .touchUpInside)
        }
        
        giphyView.do {
            $0.backgroundColor = .cyan
        }
        
        nameLabel.do {
            $0.text = "Name"
        }
        
        shareButton.do {
            $0.backgroundColor = .green
            $0.setTitle("Share", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func configureLayout() {
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            let constant = 23
            $0.top.equalTo(self.view).offset(constant)
            $0.trailing.equalTo(self.view).offset(-constant)
        }
        
        self.view.addSubview(giphyView)
        giphyView.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view).dividedBy(1.27)
            $0.width.height.equalTo(160)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(giphyView.snp.bottom).offset(5)
            $0.centerX.equalTo(giphyView.snp.centerX)
        }
        
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.width.equalTo(self.view).multipliedBy(0.8)
            $0.height.equalTo(shareButton.snp.width).multipliedBy(0.2)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(self.view).dividedBy(0.6)
        }
    }
}
