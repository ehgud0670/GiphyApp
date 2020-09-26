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

protocol DetailViewControllerDelegate: class {
    func upgrade(giphy: Giphy, at index: Int)
}

final class DetailViewController: UIViewController {
    private let gifImageView = UIImageView()
    private let nameLabel = UILabel()
    private let closeButton = CloseButton()
    private let shareButton = UIButton()
    private let favoriteButton = FavoriteButton()
    
    weak var delegate: DetailViewControllerDelegate?
    var giphy: Giphy?
    var coreDataGiphy: CoreDataGiphy?
    var giphyIndex: Int?
    var coreDataManager: CoreDataManager?
    private var disposeBag = DisposeBag()
    private let imageTask = ImageTask()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
        configureLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        ImageCache.default.clearCache()
    }
}

extension DetailViewController {
    private func configureAttributes() {
        self.view.do {
            $0.backgroundColor = .systemTeal
            $0.layer.cornerRadius = 20
        }
        
        closeButton.do {
            $0.addTarget(self, action: #selector(close), for: .touchUpInside)
        }
        
        gifImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = Images.gifPlaceholder
            guard let urlString = giphy?.downsizedURLString else { return }
            let max: CGFloat = 160
            imageTask.getImageWithRx(with: urlString, with: CGSize(width: max, height: max))
                .bind(to: $0.rx.image)
                .disposed(by: disposeBag)
        }
        
        nameLabel.do {
            $0.textAlignment = .center
            guard let title = giphy?.title.components(separatedBy: " GIF").first else { return }
            $0.text = title
        }
        
        shareButton.do {
            $0.layer.cornerRadius = 20
            $0.backgroundColor = .systemBlue
            $0.setTitle("공유", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
            $0.addTarget(self, action: #selector(share), for: .touchUpInside)
        }
        
        favoriteButton.do {
            $0.addTarget(self, action: #selector(favorite), for: .touchUpInside)
            
            guard let giphy = giphy else { return }
            if giphy.isFavorite {
                $0.toggle()
            }
        }
    }
    
    @objc private func close() {
        if let giphy = giphy, let giphyIndex = giphyIndex {
            delegate?.upgrade(giphy: giphy, at: giphyIndex)
        }
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
        favoriteButton.toggle()
        
        guard let giphy = giphy else { return }
        self.giphy?.isFavorite = !giphy.isFavorite
        
        guard let strongGiphy = self.giphy else { return }
        if strongGiphy.isFavorite {
            guard let coreDataManager = coreDataManager, !coreDataManager.isLimited
                else { Util.presetAlertWithCanNotFavorite(to: self); return }
            
            coreDataManager.insertObject(giphy: strongGiphy)
            return
        }
        
        guard let coreGiphy = coreDataGiphy else { return }
        coreDataManager?.removeObject(coreDataGiphy: coreGiphy)
    }
    
    private func configureLayout() {
        self.view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            let constant = 18
            $0.top.equalTo(self.view).offset(constant)
            $0.trailing.equalTo(self.view).offset(-constant)
        }
        
        self.view.addSubview(gifImageView)
        gifImageView.snp.makeConstraints {
            $0.centerX.equalTo(self.view)
            $0.centerY.equalTo(self.view).dividedBy(1.27)
            
            guard let size = gifImageView.image?.size else { return }
            let max: CGFloat = 160
            if size.height > size.width {
                $0.height.equalTo(max)
                let ratio = size.width / size.height
                $0.width.equalTo(gifImageView.snp.height).multipliedBy(ratio)
                return
            }
            
            let ratio = size.height / size.width
            $0.width.equalTo(max)
            $0.height.equalTo(gifImageView.snp.width).multipliedBy(ratio)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(gifImageView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(self.view).inset(10)
            $0.centerX.equalTo(gifImageView.snp.centerX)
        }
        
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.width.equalTo(self.view).multipliedBy(0.8)
            $0.height.equalTo(shareButton.snp.width).multipliedBy(0.2)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(self.view).dividedBy(0.57)
        }
        
        self.view.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.top.equalTo(gifImageView).offset(-10)
            $0.trailing.equalTo(gifImageView).offset(10)
        }
    }
}
