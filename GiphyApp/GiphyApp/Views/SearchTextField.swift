//
//  SearchTextField.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then

protocol SearchView: UIView { }

final class SearchTextField: UITextField, SearchView, Shadow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAttributes()
    }
}

extension SearchTextField {
    private func configureAttributes() {
        self.do {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.searchBarBorderGray.cgColor
            $0.layer.cornerRadius = 5
            $0.configureShadow()
        }
    }
}
