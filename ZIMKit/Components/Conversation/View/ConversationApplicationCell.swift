//
//  ConversationApplicationCell.swift
//  Pods
//
//  Created by ERay on 2026/1/16.
//

import Foundation
import ZIM
class ConversationApplicationCell: _TableViewCell {
    
    static let reuseIdentifier = String(describing: ConversationApplicationCell.self)
    
    lazy var headImageView: UIImageView = {
        let imageView = UIImageView().withoutAutoresizingMaskConstraints
        imageView.clipsToBounds = true
        imageView.image = loadImageSafely(with: "avatar_application")
        imageView.layer.cornerRadius = 26
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel().withoutAutoresizingMaskConstraints
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = L10n("conversation_application_noti")
        label.textColor = .white
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel().withoutAutoresizingMaskConstraints
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .mivoo_textGray
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel().withoutAutoresizingMaskConstraints
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .zim_textGray3
        return label
    }()
    
    lazy var unReadBubble: UIView = {
        let v =  UIView().withoutAutoresizingMaskConstraints
        v.backgroundColor = .red
        v.layer.cornerRadius = 9
        v.isHidden = true
        return v
    }()
    
    lazy var line: UIView = {
        let view = UIView().withoutAutoresizingMaskConstraints
        view.backgroundColor = .mivoo_seperatorGray
        contentView.addSubview(view)
        return view
    }()
    
    var model: ZIMFriendApplicationInfo? {
        didSet {
            updateContent()
        }
    }
    var messageTrailingConstraint: NSLayoutConstraint!
    var subtitleLeadingConstraint: NSLayoutConstraint!
    var unReadViewWidthConstraint: NSLayoutConstraint!
    override func setUp() {
        super.setUp()
        isUserInteractionEnabled = true
        backgroundColor = .mivoo_backgroundDarkBlue1
        selectionStyle = .none
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        unReadViewWidthConstraint = unReadBubble.widthAnchor.pin(equalToConstant: 18.0)
        
        contentView.addSubview(headImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(line)
        contentView.addSubview(unReadBubble)
        
        headImageView.leadingAnchor.pin(
            equalTo: contentView.leadingAnchor,
            constant: 15).isActive = true
        headImageView.pin(to: 52)
        headImageView.pin(anchors: [.centerY], to: contentView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.pin(
                equalTo: headImageView.trailingAnchor,
                constant: 11),
            titleLabel.topAnchor.pin(
                equalTo: contentView.topAnchor,
                constant: 15.5),
            titleLabel.trailingAnchor.pin(
                equalTo: timeLabel.leadingAnchor,
                constant: -16),
            titleLabel.heightAnchor.pin(equalToConstant: 22.5)
        ])
        
        subtitleLeadingConstraint = subTitleLabel.leadingAnchor.pin(equalTo: titleLabel.leadingAnchor)
        messageTrailingConstraint = subTitleLabel.trailingAnchor.pin(equalTo: contentView.trailingAnchor,constant: -28)
        NSLayoutConstraint.activate([
            subtitleLeadingConstraint,
            subTitleLabel.topAnchor.pin(equalTo: titleLabel.bottomAnchor, constant: 4),
            messageTrailingConstraint,
            subTitleLabel.heightAnchor.pin(equalToConstant: 16.5)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.pin(equalTo: contentView.topAnchor, constant: 20),
            timeLabel.trailingAnchor.pin(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.heightAnchor.pin(equalToConstant: 14.0),
            timeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            line.leadingAnchor.pin(equalTo: titleLabel.leadingAnchor),
            line.heightAnchor.pin(equalToConstant: 0.5)
        ])
        line.pin(anchors: [.trailing, .bottom], to: contentView)
        
        unReadBubble.leadingAnchor.pin(
            equalTo: headImageView.trailingAnchor,
            constant: -9).isActive = true
        unReadBubble.topAnchor.pin(
            equalTo: headImageView.topAnchor,
            constant: -9).isActive = true
        
        NSLayoutConstraint.activate([
            unReadViewWidthConstraint,
            unReadBubble.heightAnchor.pin(equalToConstant: 18.0)
        ])
        unReadViewWidthConstraint.isActive = true
    }
    
    override func updateContent() {
        super.updateContent()
        
        guard let model = model else {
            subTitleLabel.text = L10n("conversation_application_empty")
            return
        }
        // update time
        timeLabel.text = timestampToConversationDateStr(UInt64(model.createTime))
        
        // update subtitle
        let title = L10n("conversation_application_friend_invite")
        let description = L10n("conversation_application_description", model.applyUser.userName)

        let attributedText = NSMutableAttributedString(
            string: title,
            attributes: [.foregroundColor: UIColor(hex: "#F96261")]
        )

        let descriptionAttr = NSAttributedString(
            string: description,
            attributes: [.foregroundColor: UIColor.white]
        )
        attributedText.append(descriptionAttr)
        subTitleLabel.attributedText = attributedText
        
        contentView.backgroundColor = UIColor(hex: "#1F1A2F")
        
        self.layoutIfNeeded()
    }
    
    func updateUnreadStatus(isUnread: Bool) {
        unReadBubble.isHidden = !isUnread
    }
}
