//
//  GiphyCell.swift
//  GiphyApp
//
//  Created by kimdo2297 on 2020/09/22.
//  Copyright © 2020 jason. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import Kingfisher
import SnapKit

final class GifCell: UICollectionViewCell, ReuseIdentifier {
    private var gifImageView = UIImageView()
    private var disposeBag = DisposeBag()
    private var data = PublishSubject<GiphyData>()
    let onData: AnyObserver<GiphyData>
    
    override init(frame: CGRect) {
        self.onData = data.asObserver()
        
        super.init(frame: frame)
        
        configureLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        let data = PublishSubject<GiphyData>()
        self.onData = data.asObserver()
        
        super.init(coder: coder)
        
        configureLayout()
        bindUI()
    }
    
    // MARK: - Layout
    private func configureLayout() {
        self.contentView.addSubview(gifImageView)
        
        gifImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.contentView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        clear()
        disposeBag = DisposeBag()
        bindUI()
    }
    
    private func clear() {
        gifImageView.image = Images.gifPlaceholder
    }
    
    private func bindUI() {
        data.compactMap { $0.images.original?.url }
            .bind { [weak self] in
                self?.gifImageView.setImageWithMemoryCache(
                    urlString: $0,
                    placeholder: Images.gifPlaceholder
                )}
            .disposed(by: disposeBag)
    }
}
