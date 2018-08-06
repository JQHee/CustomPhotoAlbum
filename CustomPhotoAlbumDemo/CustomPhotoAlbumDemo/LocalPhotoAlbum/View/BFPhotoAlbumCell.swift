//
//  BFPhotoAlbumCell.swift
//  ThreeBuild
//
//  Created by HJQ on 2018/8/4.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import UIKit

class BFPhotoAlbumCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Private methods
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Lazy load
    lazy var imageView: UIImageView = UIImageView()

}
