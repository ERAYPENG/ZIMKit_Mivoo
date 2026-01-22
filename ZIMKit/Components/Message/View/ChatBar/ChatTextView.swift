//
//  ChatTextView.swift
//  ZIMKit
//
//  Created by Kael Ding on 2022/8/10.
//

import Foundation

let textViewTBMargin: CGFloat = 5
let textViewLRMargin: CGFloat = 10.0

protocol TextViewCancelReplyMessageDelegate: NSObjectProtocol {
    func chatTextCancelReplyMessage()
}

protocol TextViewDelegate: UITextViewDelegate {
    func textViewDeleteBackward(_ textView: TextView)
}

protocol textViewToolBarDelegate: NSObjectProtocol {
    func didClickFullScreenEnter()
    func didClicksendMessage()
}


class TextView: UITextView {
    
    override func deleteBackward() {
        if let delegate = delegate as? TextViewDelegate {
            delegate.textViewDeleteBackward(self)
        }
        super.deleteBackward()
    }
    
    override var text: String! {
        didSet {
            delegate?.textViewDidChange?(self)
        }
    }
}

class ChatTextView: _View {

    var sendButton: UIButton?

    lazy var placeholderLabel: UILabel = {
        let label: UILabel = UILabel().withoutAutoresizingMaskConstraints
        label.attributedText = ZIMKit().imKitConfig.inputPlaceholder
        return label
    }()

    lazy var textView: TextView = {
        let view = TextView().withoutAutoresizingMaskConstraints
        view.font = UIFont.systemFont(ofSize: 16)
        view.textColor = .white
        view.backgroundColor = .mivoo_backgroundDarkBlue2
        view.returnKeyType = .default
        return view
    }()

    lazy var sendButtonView: UIButton = {
        let button: UIButton = UIButton().withoutAutoresizingMaskConstraints
        button.setImage(loadImageSafely(with: "btn_send"), for: .normal)
        button.setImage(loadImageSafely(with: "btn_send_no_enable"), for: .disabled)
        button.addTarget(self, action: #selector(sendMessageAction), for: .touchUpInside)
        button.isEnabled = false
        self.sendButton = button
        return button
    }()

    var textviewTopConstraint: NSLayoutConstraint!

    weak var delegate: textViewToolBarDelegate?
    weak var replyDelegate: TextViewCancelReplyMessageDelegate?

    override func setUp() {
        super.setUp()
        backgroundColor = .mivoo_backgroundDarkBlue1
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
        setUpSubViews()
    }

    func setUpSubViews() {
        addSubview(textView)
        addSubview(sendButtonView)
        textView.addSubview(placeholderLabel)
    }

    override func setUpLayout() {
        super.setUpLayout()

        textviewTopConstraint = textView.topAnchor.pin(equalTo: self.topAnchor, constant: textViewTBMargin)
        NSLayoutConstraint.activate([
            textviewTopConstraint,
            textView.bottomAnchor.pin(equalTo: self.bottomAnchor, constant: -textViewTBMargin),
            textView.leadingAnchor.pin(equalTo: self.leadingAnchor, constant: textViewLRMargin),
            textView.trailingAnchor.pin(equalTo: self.trailingAnchor, constant: -textViewLRMargin - 36)
        ])

        NSLayoutConstraint.activate([
            sendButtonView.topAnchor.pin(equalTo: textView.topAnchor),
            sendButtonView.trailingAnchor.pin(equalTo: self.trailingAnchor, constant: -5),
            sendButtonView.widthAnchor.pin(equalToConstant: 36),
            sendButtonView.heightAnchor.pin(equalToConstant: 36)
        ])

        NSLayoutConstraint.activate([
            placeholderLabel.centerYAnchor.pin(equalTo: textView.centerYAnchor),
            placeholderLabel.leadingAnchor.pin(equalTo: textView.leadingAnchor, constant: 6),
            placeholderLabel.heightAnchor.pin(equalToConstant: 20)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        textviewTopConstraint.constant = textViewTBMargin
        textviewTopConstraint.isActive = true
    }

    @objc func sendMessageAction() {
        delegate?.didClicksendMessage()
    }
}
