//
//  DetailViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then

final class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAttributes()
    }
}

extension DetailViewController {
    func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .blue
        }
    }
}
