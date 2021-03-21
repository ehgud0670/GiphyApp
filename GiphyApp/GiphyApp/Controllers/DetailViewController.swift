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
import Kingfisher
import RxSwift

final class DetailViewController: UIViewController {
    // MARK: - UI
    private let giphyImageView = UIImageView()
    private let nameLabel = UILabel()
    private let closeButton = CloseButton()
    private let shareButton = UIButton()
    private let favoriteButton = FavoriteButton()
    
    // MARK: - Properties
    var giphy: Giphy?
    var coreDataManager: CoreDataGiphyViewModel?
    private var disposeBag = DisposeBag()
    private let imageUseCase = ImageUseCase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ImageCache.default.clearCache()
    }
    
    // MARK: @objc function
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    @objc private func share() {
        guard let imageURLString = giphy?.originalURLString else { return }
        
        let textToShare = [imageURLString]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func favorite() {
        guard let giphy = giphy else { return }
        self.giphy?.isFavorite = !giphy.isFavorite
        
        guard let strongGiphy = self.giphy else { return }
        if strongGiphy.isFavorite {
            guard let coreDataManager = coreDataManager, !coreDataManager.isLimited
                else { Util.presetAlertWithCanNotFavorite(on: self); return }
            
            favoriteButton.isFavorited = true
            coreDataManager.insertObject(giphy: strongGiphy)
            return
        }
        
        favoriteButton.isFavorited = false
        guard let coreGiphy = coreDataManager?.object(giphy: strongGiphy) else { return }
        
        coreDataManager?.removeObject(coreDataGiphy: coreGiphy)
    }
}

// MARK: - Attributes & Layout
extension DetailViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .subDark
            $0.layer.cornerRadius = 20
        }
        
        closeButton.do {
            $0.addTarget(self, action: #selector(close), for: .touchUpInside)
        }
        
        giphyImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = UIImage.from(color: .mainDark)
            guard let urlString = giphy?.originalURLString else { return }
            let max: CGFloat = 160
            imageUseCase.animatedImageWithRx(with: urlString, with: CGSize(width: max, height: max))
                .bind(to: $0.rx.image)
                .disposed(by: disposeBag)
        }
        
        nameLabel.do {
            $0.textAlignment = .center
            $0.font = .preferredFont(forTextStyle: .callout)
            $0.adjustsFontForContentSizeCategory = true
            $0.adjustsFontSizeToFitWidth = true
            guard let title = giphy?.title.components(separatedBy: " GIF").first else { return }
            $0.text = title
        }
        
        shareButton.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .systemPink
            $0.setTitle("공유", for: .normal)
            $0.titleLabel?.font = .preferredFont(forTextStyle: .title3)
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.adjustsFontForContentSizeCategory = true
            $0.titleLabel?.adjustsFontSizeToFitWidth = true
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
            $0.addTarget(self, action: #selector(share), for: .touchUpInside)
        }
        
        favoriteButton.do {
            $0.addTarget(self, action: #selector(favorite), for: .touchUpInside)
            
            guard let giphy = giphy,
                let coreDataGiphy = coreDataManager?.object(giphy: giphy),
                coreDataGiphy.isFavorite else { return }
            
            $0.isFavorited = true
            self.giphy?.isFavorite = true
        }
    }
    
    private func configureLayout() {
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            let constant = 18
            $0.top.equalTo(self.view).offset(constant)
            $0.trailing.equalTo(self.view).offset(-constant)
        }
        
        self.view.addSubview(giphyImageView)
        giphyImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view).dividedBy(1.27)
            
            guard let size = giphyImageView.image?.size else { return }
            
            let max: CGFloat = 160
            if size.height > size.width {
                $0.height.equalTo(max)
                let ratio = size.width / size.height
                $0.width.equalTo(giphyImageView.snp.height).multipliedBy(ratio)
                return
            }
            
            let ratio = size.height / size.width
            $0.width.equalTo(max)
            $0.height.equalTo(giphyImageView.snp.width).multipliedBy(ratio)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(giphyImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(self.view).inset(10)
            $0.centerX.equalTo(giphyImageView.snp.centerX)
        }
        
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.width.equalTo(self.view).multipliedBy(0.8)
            $0.height.equalTo(shareButton.snp.width).multipliedBy(0.2)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(self.view).dividedBy(0.57)
        }
        
        shareButton.titleLabel?.snp.makeConstraints {
            $0.leading.trailing.equalTo(shareButton).inset(10)
        }
        
        self.view.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(giphyImageView).offset(-10)
            $0.trailing.equalTo(giphyImageView).offset(10)
        }
    }
}
