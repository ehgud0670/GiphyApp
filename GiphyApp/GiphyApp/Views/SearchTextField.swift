//
//  SearchTextField.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then

final class SearchTextField: UITextField, Shadow {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureAttributes()
    }
    
    func setAccessibilityLabel(with text: String) {
        self.accessibilityLabel = "search text value: \(text)"
    }
}

extension SearchTextField {
    private func configureAttributes() {
        self.do {
            $0.accessibilityIdentifier = "SearchTextField"
            $0.accessibilityLabel = "search text value is empty"
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.searchBarBorderGray.cgColor
            $0.layer.cornerRadius = 5
            $0.font = .preferredFont(forTextStyle: .title3)
            $0.adjustsFontForContentSizeCategory = true
            $0.adjustsFontSizeToFitWidth = true
            $0.configureShadow()
        }
    }
}
