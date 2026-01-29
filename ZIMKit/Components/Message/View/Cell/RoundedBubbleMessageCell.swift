//
//  RoundedBubbleMessageCell.swift
//  Pods
//
//  Created by ERay on 2026/1/29.
//

import UIKit
import ZIM

class RoundedBubbleMessageCell: MessageCell {
    
    override class var reuseId: String {
        String(describing: RoundedBubbleMessageCell.self)
    }
    
    lazy var bubbleView: UIView = {
        let view = UIView().withoutAutoresizingMaskConstraints
        return view
    }()
    
    var bubbleLeftConstraint: NSLayoutConstraint!
    var bubbleRightConstraint: NSLayoutConstraint!
    var bubbleTopConstraint: NSLayoutConstraint!
    var bubbleBottomConstraint: NSLayoutConstraint!
    
    override func setUp() {
        super.setUp()
        
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = true
    }
    
    override func setUpLayout() {
        super.setUpLayout()
        
        containerView.addSubview(bubbleView)
        
        bubbleLeftConstraint = bubbleView.leadingAnchor.pin(equalTo: containerView.leadingAnchor, constant: 0)
        bubbleRightConstraint = bubbleView.rightAnchor.pin(equalTo: containerView.rightAnchor, constant: 0)
        bubbleTopConstraint = bubbleView.topAnchor.pin(equalTo: containerView.topAnchor, constant: 0)
        bubbleBottomConstraint = bubbleView.bottomAnchor.pin(equalTo: containerView.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            bubbleLeftConstraint,
            bubbleRightConstraint,
            bubbleTopConstraint,
            bubbleBottomConstraint
        ])
        
        bubbleLeftConstraint.isActive = true
        bubbleRightConstraint.isActive = true
        bubbleTopConstraint.isActive = true
        bubbleBottomConstraint.isActive = true
    }
    
    override func updateContent() {
        super.updateContent()
        
        guard let messageVM = messageVM else { return }
        let direction = messageVM.message.info.direction
        
        if direction == .send {
            bubbleView.backgroundColor = UIColor(hex: "#6277E6")
            bubbleView.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            bubbleView.layer.borderWidth = 0
            bubbleView.layer.borderColor = nil
        } else {
            bubbleView.backgroundColor = UIColor(hex: "#191828")
            bubbleView.layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            bubbleView.layer.borderWidth = 1 * scaled
            bubbleView.layer.borderColor = UIColor(hex: "#2E2E2E").withAlphaComponent(0.57).cgColor
        }
    }
}
