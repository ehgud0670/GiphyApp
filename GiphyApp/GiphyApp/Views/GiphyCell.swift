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

final class GiphyCell: UICollectionViewCell, ReuseIdentifier {
    private var giphyImageView = UIImageView().then {
        $0.image = Images.gifPlaceholder
    }
    private var disposeBag = DisposeBag()
    private var data = PublishSubject<Giphy>()
    let onData: AnyObserver<Giphy>
    private let imageUseCase = ImageUseCase.shared
    
    override init(frame: CGRect) {
        self.onData = data.asObserver()
        
        super.init(frame: frame)
        
        configureAttributes()
        configureLayout()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        let data = PublishSubject<Giphy>()
        self.onData = data.asObserver()
        
        super.init(coder: coder)
        
        configureAttributes()
        configureLayout()
        bindUI()
    }
    
    // MARK: - Attributes & Layout
    private func configureAttributes() {
        giphyImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.masksToBounds = true
        }
    }
    
    private func configureLayout() {
        self.contentView.addSubview(giphyImageView)
        
        giphyImageView.snp.makeConstraints {
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
        giphyImageView.image = Images.gifPlaceholder
    }
    
    private func bindUI() {
        data.compactMap { $0.originalURLString }
            .flatMap { self.imageUseCase.animatedImageWithRx(with: $0, with: self.bounds.size) }
            .bind(to: giphyImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
