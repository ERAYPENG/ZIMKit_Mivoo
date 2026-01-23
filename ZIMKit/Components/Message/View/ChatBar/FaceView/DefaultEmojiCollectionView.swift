//
//  DefaultEmojiCollectionView.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/8/12.
//

import Foundation
import UIKit

protocol DefaultEmojiCollectionViewDelegate: AnyObject {
    func defaultEmojiCollectionViewDidSelectItem(with emoji: String)
    func defaultEmojiCollectionViewDidDeleteButtonClicked()
    func defaultEmojiCollectionViewDidSendButtonClicked()
}

class DefaultEmojiCollectionView: _CollectionViewCell {

    static let reuseIdentifier = String(describing: DefaultEmojiCollectionView.self)

    weak var delegate: DefaultEmojiCollectionViewDelegate?

    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        //        layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: bounds,
            collectionViewLayout: flowLayout)
            .withoutAutoresizingMaskConstraints
        collectionView.backgroundColor = .mivoo_backgroundDarkBlue1
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = true
        // below iOS 13, the `contentInset` will reload the collection view,
        // so we should register cell first, to avoid the crash.
        collectionView.register(DefaultEmojiCell.self,
                                forCellWithReuseIdentifier: DefaultEmojiCell.reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 16*2+15, right: 15)
        return collectionView
    }()

    lazy var emojiList: [String] = ZIMKit().imKitConfig.bottomConfig.emojis

    var buttonBackgroundHeightConstraint: NSLayoutConstraint!

    override func setUp() {
        super.setUp()
        contentView.backgroundColor = .zim_backgroundGray2
    }

    override func setUpLayout() {
        super.setUpLayout()

        contentView.addSubview(collectionView)

        collectionView.pin(to: self)
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        buttonBackgroundHeightConstraint.constant = 98+safeAreaInsets.bottom
    }
}

// MARK: - Actions
extension DefaultEmojiCollectionView {
    @objc func deleteButtonClick(_ sender: UIButton) {
        delegate?.defaultEmojiCollectionViewDidDeleteButtonClicked()
    }

    @objc func sendButtonClick(_ sender: UIButton) {
        delegate?.defaultEmojiCollectionViewDidSendButtonClicked()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension DefaultEmojiCollectionView:   UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultEmojiCell.reuseIdentifier, for: indexPath) as? DefaultEmojiCell else {
            return DefaultEmojiCell()
        }
        if indexPath.row >= emojiList.count {
            return DefaultEmojiCell()
        }
        cell.delegate = self
        cell.fillData(emojiList[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.width - 2 * 15.0 - 6 * 5.0) / 7.0
        return CGSize(width: width, height: width)
    }
}

extension DefaultEmojiCollectionView: DefaultEmojiCellDelegate {
    func defaultEmojiCellClicked(with emoji: String) {
        delegate?.defaultEmojiCollectionViewDidSelectItem(with: emoji)
    }
}
