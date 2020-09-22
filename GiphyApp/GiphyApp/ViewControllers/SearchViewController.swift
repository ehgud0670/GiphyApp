//
//  ViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import ReactorKit
import Then
import SnapKit

final class SearchViewController: UIViewController, StoryboardView {
    private let searchView: SearchView = SearchTextField()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchViewLayout()
    }
    
    func bind(reactor: SearchReactor) {
        
    }
}

// MARK: - Attributes & Layout
extension SearchViewController {
    private func configureSearchViewLayout() {
        self.view.do {
            $0.addSubview(searchView)
        }
        
        searchView.snp.makeConstraints {
            let safeArea = self.view.safeAreaLayoutGuide
            $0.top.leading.trailing.equalTo(safeArea).inset(10)
            $0.height.equalTo(searchView.snp.width).dividedBy(7)
        }
    }
}
