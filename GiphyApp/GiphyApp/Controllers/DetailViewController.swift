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
    private let closeButton = CloseButton()
    
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
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    private func configureLayout() {
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            let constant = 27
            $0.top.equalTo(self.view).offset(constant)
            $0.trailing.equalTo(self.view).offset(-constant)
        }
    }
}
