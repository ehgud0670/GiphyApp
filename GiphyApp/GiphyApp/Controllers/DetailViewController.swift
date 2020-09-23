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

final class DetailViewController: UIViewController {
    private let gifImageView = UIImageView()
    private let nameLabel = UILabel()
    private let closeButton = CloseButton()
    private let shareButton = UIButton()
    var giphyData: GiphyData?
    
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
            
            guard let urlString = giphyData?.images.original?.url else { return }
            $0.setImageWithMemoryCache(
                urlString: urlString,
                placeholder: Images.gifPlaceholder)
        }
        
        shareButton.do {
            $0.backgroundColor = .green
            $0.setTitle("Share", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.addTarget(self, action: #selector(share), for: .touchUpInside)
        }
    }
    
    @objc private func close() {
        self.dismiss(animated: true)
    }
    
    @objc private func share() {
        guard let imageURLString = giphyData?.images.original?.url else { return }
        
        let textToShare = [imageURLString]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]
    
        self.present(activityViewController, animated: true, completion: nil)
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
            $0.width.height.equalTo(160)
        }
        
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(gifImageView.snp.bottom).offset(5)
            $0.centerX.equalTo(gifImageView.snp.centerX)
        }
        
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints {
            $0.width.equalTo(self.view).multipliedBy(0.8)
            $0.height.equalTo(shareButton.snp.width).multipliedBy(0.2)
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.centerY.equalTo(self.view).dividedBy(0.57)
        }
    }
}
