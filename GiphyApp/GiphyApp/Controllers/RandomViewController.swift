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
import RxSwift
import RxCocoa
import Kingfisher

final class RandomViewController: UIViewController {
    // MARK: - UI
    private let searchTextField = SearchTextField()
    private let randomButton = UIButton()
    private let shareButton = UIButton()
    private let giphyImageView = UIImageView()
    private lazy var alertController = UIAlertController(
        title: "클릭! 버튼을 먼저 눌러주세요",
        message: nil,
        preferredStyle: .alert
    ).then {
        $0.addAction(UIAlertAction(title: "OK", style: .default))
    }
    
    // MARK: - Properties
    private let giphySubject = BehaviorSubject<GiphyData?>(value: nil)
    private let giphyTask = GiphyTask()
    private let imageUseCase = ImageUseCase()
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
        configureBinding()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ImageCache.default.clearMemoryCache()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - Attributes & Layout
extension RandomViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .black
        }
        
        searchTextField.do {
            let color = UIColor.white
            $0.layer.borderColor = color.cgColor
            $0.textColor = color
            
            let attributes = [ NSAttributedString.Key.foregroundColor: color ]
            let placeHolderString = NSAttributedString(string: "랜덤 검색", attributes: attributes)
            $0.attributedPlaceholder = placeHolderString
        }
        
        giphyImageView.do {
            $0.image = Images.randomPlaceholder
            $0.backgroundColor = .lightGray
        }
        
        randomButton.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .systemPink
            $0.setTitle("클릭!", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
            $0.titleLabel?.font = .preferredFont(forTextStyle: .title3)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.adjustsFontForContentSizeCategory = true
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
        }
        
        shareButton.do {
            $0.layer.cornerRadius = 10
            $0.backgroundColor = .systemBlue
            $0.setTitle("공유", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
            $0.titleLabel?.font = .preferredFont(forTextStyle: .title3)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.adjustsFontForContentSizeCategory = true
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
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
        
        self.view.addSubview(giphyImageView)
        giphyImageView.snp.makeConstraints {
            $0.width.height.equalTo(self.view.snp.width).dividedBy(1.5)
            $0.centerX.equalTo(self.view)
            let constant = 30
            $0.top.equalTo(searchTextField.snp.bottom).offset(constant)
        }
        
        self.view.addSubview(randomButton)
        randomButton.snp.makeConstraints {
            $0.width.equalTo(self.view.snp.width).dividedBy(1.5)
            $0.height.equalTo(randomButton.snp.width).multipliedBy(0.2)
            $0.centerX.equalTo(self.view.snp.centerX)
            let constant = 15
            $0.top.equalTo(giphyImageView.snp.bottom).offset(constant)
        }
        
        randomButton.titleLabel?.snp.makeConstraints {
            $0.leading.trailing.equalTo(randomButton).inset(10)
        }
        
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.width.equalTo(randomButton.snp.width)
            $0.height.equalTo(randomButton.snp.height)
            $0.centerX.equalTo(self.view.snp.centerX)
            let constant = 15
            $0.top.equalTo(randomButton.snp.bottom).offset(constant)
        }
        
        shareButton.titleLabel?.snp.makeConstraints {
            $0.leading.trailing.equalTo(shareButton).inset(10)
        }
    }
}

// MARK: - Binding
extension RandomViewController {
    private func configureBinding() {
        randomButton.rx.tap
            .withLatestFrom(
                self.searchTextField.rx.text.orEmpty.distinctUntilChanged(),
                resultSelector: { return $1 })
            .flatMap { self.giphyTask.perform(RandomRequest(tag: $0))}
            .map { $0.data }
            .bind(to: giphySubject)
            .disposed(by: disposeBag)
        
        giphySubject
            .compactMap { $0 }
            .compactMap { $0.images.original?.url }
            .flatMap { self.imageUseCase.animatedImageWithRx(with: $0, with: self.giphyImageView.bounds.size) }
            .bind(to: giphyImageView.rx.image )
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .withLatestFrom(giphySubject)
            .do(onNext: { if $0 == nil { self.present(self.alertController, animated: true) } })
            .compactMap { $0 }
            .compactMap { $0.images.original?.url }
            .subscribe(onNext: {
                let activityViewController = UIActivityViewController(
                    activityItems: [$0],
                    applicationActivities: nil
                ).then {
                    $0.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
                }
                self.present(activityViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
