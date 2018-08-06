//
//  BFPhotoAlbumViewController.swift
//  ThreeBuild
//
//  Created by HJQ on 2018/8/4.
//  Copyright © 2018年 HJQ. All rights reserved.
//

import UIKit
import SnapKit

protocol BFPhotoAlbumViewControllerDelegate: class {
    func photoAlbumViewControllerSelectFinish(image: UIImage)
}

// MARK: - 自定义相册
private let cellID = "BFPhotoAlbumCell"
class BFPhotoAlbumViewController: UIViewController {

    private var datas = [BFPhotoAlbumModel]()
    weak var delegate: BFPhotoAlbumViewControllerDelegate?
    var type: PhotoAlbumType = .safeNew

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "相册"
        setupUI()
        BFPhotoAlbumFMDBManager.shared.queryDatas(type: type) { [weak self](datas) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.datas = datas
            strongSelf.collectionView.reloadData()

        }
    }

    // MARK: - Private methods
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Lazy load
    private lazy var collectionView: UICollectionView = { [weak self] in
        let collectionView: UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BFPhotoAlbumCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
}

// MARK: - UICollectionViewDelegate
extension BFPhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let image = UIImage(contentsOfFile: datas[indexPath.item].path) else {
            return
        }
        if let _ = delegate {
            delegate?.photoAlbumViewControllerSelectFinish(image: image)
            navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - UICollectionViewDataSource
extension BFPhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BFPhotoAlbumCell else {
            return UICollectionViewCell()
        }
        let data = datas[indexPath.item]
        cell.imageView.image = UIImage(contentsOfFile: data.path)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BFPhotoAlbumViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let column: Int = 4
        let space: CGFloat = 1.0
        let width = (UIScreen.main.bounds.width - 26.0 - (CGFloat(column - 1) * space)) / CGFloat(column)
        return CGSize(width: width, height: width)
    }
}
