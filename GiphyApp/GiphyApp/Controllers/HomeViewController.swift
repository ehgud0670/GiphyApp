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
import Kingfisher
import Alamofire

final class HomeViewController: UIViewController {
    // MARK: - UI
    private let searchTextField = SearchTextField()
    private let giphyCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    // MARK: - Properties
    private let giphysViewModel = GiphysViewModel()
    private let giphysUseCase = GiphysUseCase(giphysTask: GiphysTask())
    private var disposeBag = DisposeBag()
    var coreDataManager: CoreDataGiphyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
        configureObservers()
        configureBindings()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ImageCache.default.clearMemoryCache()
    }
    
    private func configureObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadDataCollectionView),
            name: GiphysViewModel.Notification.updateFirst,
            object: giphysViewModel
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadItemsCollectionView(_:)),
            name: GiphysViewModel.Notification.updateMore,
            object: giphysViewModel
        )
    }
    
    @objc private func reloadDataCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.giphyCollectionView.setContentOffset(.zero, animated: false)
            self?.giphyCollectionView.reloadData()
        }
    }
    
    @objc private func reloadItemsCollectionView(_ notification: Notification) {
        guard let newItems = notification.userInfo?["newItems"] as? [IndexPath] else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.giphyCollectionView.insertItems(at: newItems)
        }
    }
}

// MARK: - Attributes & Layout
extension HomeViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .systemPurple
        }
        
        giphyCollectionView.do {
            $0.backgroundColor = .systemPurple
            $0.register(GiphyCell.self, forCellWithReuseIdentifier: GiphyCell.reuseIdentifier)
            $0.dataSource = giphysViewModel
            $0.delegate = self
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            let safeArea = self.view.safeAreaLayoutGuide
            let constant: CGFloat = 10
            
            $0.top.equalTo(safeArea).inset(constant)
            $0.leading.trailing.equalTo(self.view).inset(constant)
            $0.height.equalTo(searchTextField.snp.width).dividedBy(7)
        }
        
        self.view.addSubview(giphyCollectionView)
        giphyCollectionView.snp.makeConstraints {
            let constant: CGFloat = 10
            
            $0.top.equalTo(searchTextField.snp.bottom).offset(constant)
            $0.leading.trailing.bottom.equalTo(self.view).inset(constant)
        }
    }
}

// MARK: - Scroll
extension HomeViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isSearchingWhenScrollIsNotTop {
            view.endEditing(true)
        }
        
        guard scrollView.isBouncingBottom,
            let pagination = giphysViewModel.pagination,
            giphysUseCase.isNotLoading else { return }
        
        let nextOffset = pagination.count + pagination.offset
        
        if isSearching {
            giphysUseCase.loadMoreSearchGiphys(
                with: searchTextField.text!,
                nextOffset: nextOffset)
                .subscribe(
                    onNext: { [weak self] in self?.giphysViewModel.updateMore(with: $0) },
                    onError: { if $0.isSessionError { Util.presentAlertWithNetworkError(on: self) } })
                .disposed(by: disposeBag)
            return
        }
        
        giphysUseCase.loadMoreTrendyGiphys(with: nextOffset)
            .subscribe(
                onNext: { [weak self] in self?.giphysViewModel.updateMore(with: $0) },
                onError: { if $0.isSessionError { Util.presentAlertWithNetworkError(on: self) } })
            .disposed(by: disposeBag)
    }
    
    private var isSearching: Bool {
        return searchTextField.text != nil && searchTextField.text != ""
    }
    
    // 스크롤 위치가 top이 아닌 경우에만 키보드를 내리게 한다.
    private var isSearchingWhenScrollIsNotTop: Bool {
        giphyCollectionView.contentOffset != .zero && searchTextField.isEditing
    }
}

// MARK: - Binding
extension HomeViewController {
    private func configureBindings() {
        // use trend API
        searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .filter { $0 == "" }
            .do { [weak self] in
                self?.giphysViewModel.clear()
                ImageCache.default.clearMemoryCache() }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, self.giphysUseCase.isNotLoading else { return }
                
                self.giphysUseCase.loadFirstTrendyGiphys()
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
                    .subscribe(
                        onNext: { self.giphysViewModel.updateFirst(with: $0) },
                        onError: { if $0.isSessionError { Util.presentAlertWithNetworkError(on: self) } })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
        // use search API
        searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInteractive))
            .filter { $0 != "" }
            .do(onNext: {  [weak self] in
                self?.searchTextField.setAccessibilityLabel(with: $0)
                self?.giphysViewModel.clear()
                ImageCache.default.clearMemoryCache()
            })
            .subscribe(onNext: { [weak self] in
                guard let self = self, self.giphysUseCase.isNotLoading else { return }
                
                self.giphysUseCase.loadFirstSearchGiphys(with: $0)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .utility))
                    .subscribe(
                        onNext: { self.giphysViewModel.updateFirst(with: $0) },
                        onError: { if $0.isSessionError { Util.presentAlertWithNetworkError(on: self) } })
                    .disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let giphy = giphysViewModel.giphy(at: indexPath.item) else { return }
        
        let detailViewController = DetailViewController().then {
            $0.giphy = giphy
            $0.coreDataManager = self.coreDataManager
            $0.modalPresentationStyle = .custom
            $0.transitioningDelegate = self
        }
        
        self.present(detailViewController, animated: true)
    }
}

// MARK: - UIViewController Transitioning Delegate
extension HomeViewController: UIViewControllerTransitioningDelegate {
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
extension HomeViewController: UICollectionViewDelegateFlowLayout {
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
