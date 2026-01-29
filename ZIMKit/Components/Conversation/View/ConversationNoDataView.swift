//
//  ConversationNoDataView.swift
//  ZIMKitConversation
//
//  Created by Kael Ding on 2022/8/4.
//

import Foundation
import UIKit

protocol ConversationNoDataViewDelegate: AnyObject {
    func onNoDataViewButtonClick()
}

class ConversationNoDataView: _View {

    weak var delegate: ConversationNoDataViewDelegate?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView().withoutAutoresizingMaskConstraints
        imageView.contentMode = .scaleAspectFit
        imageView.image = loadImageSafely(with: "cat_magnet")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel().withoutAutoresizingMaskConstraints
        label.textColor = .zim_textGray1
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.text = L10n("conversation_empty")
        return label
    }()

    override func setUp() {
        super.setUp()
        addSubview(imageView)
        addSubview(titleLabel)
    }

    override func setUpLayout() {
        super.setUpLayout()

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40 * scaled),
            imageView.widthAnchor.constraint(equalToConstant: 150 * scaled),
            imageView.heightAnchor.constraint(equalToConstant: 150 * scaled),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20 * scaled),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20 * scaled)
        ])
    }
}
