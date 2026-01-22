//
//  ShareCardMessageViewModel.swift
//  Pods
//
//  Created by ERay on 2026/1/22.
//

final class ShareCardMessageViewModel: MediaMessageViewModel {

    override init(with msg: ZIMKitMessage) {
        super.init(with: msg)
    }

    convenience init(
        shopId: Int,
        cardId: Int,
        shareUserId: Int,
        name: String,
        cardUrl: String,
        level: Int,
        zodiacSign: Int,
        price: Int
    ) {
        let msg = ZIMKitMessage()
        msg.type = .custom

        msg.shareCardContent.shopId = shopId
        msg.shareCardContent.cardId = cardId
        msg.shareCardContent.shareUserId = shareUserId
        msg.shareCardContent.name = name
        msg.shareCardContent.cardUrl = cardUrl
        msg.shareCardContent.level = level
        msg.shareCardContent.zodiacSign = zodiacSign
        msg.shareCardContent.price = price

        let dict: [String: Any] = [
            "subType": CustomMessageSubType.shareCard.rawValue,
            "shareCard": [
                "shopId": shopId,
                "cardId": cardId,
                "shareUserId": shareUserId,
                "name": name,
                "cardUrl": cardUrl,
                "level": level,
                "zodiacSign": zodiacSign,
                "price": price
            ]
        ]

        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            msg.zim?.extendedData = jsonString
        }

        self.init(with: msg)
    }

    override var contentSize: CGSize {
        contentMediaSize = CGSize(width: 209 * scaled, height: 321 * scaled)
        _contentSize = contentMediaSize

        if !message.reactions.isEmpty, message.replyMessage == nil {
            _contentSize.width += 24
            _contentSize.height += 20
        }

        return _contentSize
    }
}
