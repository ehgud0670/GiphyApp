//
//  ViewController.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import Then
import SnapKit
import RxSwift
import RxCocoa

final class SearchViewController: UIViewController {
    // MARK: - UI
    private let searchView: SearchView = SearchTextField()
    private let gifCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private let searchViewModel = SearchViewModel()
    private let gifsUseCase = GifsUseCase(gifsTask: GifsTask())
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
        configureObserver()
        loadTrendyGIFs()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        disposeBag = DisposeBag()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureBindings()
    }
    
    private func configureObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCollectionView),
            name: GifsViewModel.Notification.update,
            object: searchViewModel.gifsViewModel
        )
    }
    
    @objc private func updateCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.gifCollectionView.reloadData()
        }
    }
}

// MARK: - Attributes & Layout
extension SearchViewController {
    private func configureAttributes() {
        gifCollectionView.do {
            $0.backgroundColor = .systemBackground
            $0.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseIdentifier)
            $0.dataSource = searchViewModel.gifsViewModel
            $0.delegate = self
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(searchView)
        searchView.snp.makeConstraints {
            let safeArea = self.view.safeAreaLayoutGuide
            let constant: CGFloat = 10
            
            $0.top.equalTo(safeArea).inset(constant)
            $0.leading.trailing.equalTo(self.view).inset(constant)
            $0.height.equalTo(searchView.snp.width).dividedBy(7)
        }
        
        self.view.addSubview(gifCollectionView)
        gifCollectionView.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.top.equalTo(searchView.snp.bottom).offset(constant)
            $0.leading.trailing.bottom.equalTo(self.view).inset(constant)
        }
    }
}

// MARK: - Networks
extension SearchViewController {
    private func loadTrendyGIFs() {
        gifsUseCase.request(
            TrendRequest(),
            completionHandler: { [weak self] response in
                self?.searchViewModel.gifsViewModel.update(with: response)
            },
            failureHandler: { _ in
                
        })
    }
}

// MARK: - Binding
extension SearchViewController {
    private func configureBindings() {
        
    }
}

// MARK: - UICollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController().then {
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
        }
        
        self.present(detailViewController, animated: true)
    }
}

// MARK: - UIViewController Transitioning Delegate
extension SearchViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return HalfSizePresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let constant = (self.view.bounds.width - collectionView.frame.width) / 2
        let diameter = (collectionView.frame.width - 2 * constant) / 3
        return CGSize(width: diameter.rounded(.down), height: diameter)
    }
}
