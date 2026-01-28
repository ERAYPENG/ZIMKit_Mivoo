//
//  ZIMKit+EventHandler.swift
//  Pods
//
//  Created by ERay on 2026/1/21.
//

import ZIM

extension ZIMKit {
    
    // MARK: - User
    @objc public static func zim(_ zim: ZIM, connectionStateChanged state: ZIMConnectionState, event: ZIMConnectionEvent, extendedData: [AnyHashable : Any]) {
        ZIMKitCore.shared.zim(zim, connectionStateChanged: state, event: event, extendedData: extendedData)
    }
    
    // MARK: - Conversation
    @objc public static func zim(_ zim: ZIM, conversationChanged conversationChangeInfoList: [ZIMConversationChangeInfo]) {
        ZIMKitCore.shared.zim(zim, conversationChanged: conversationChangeInfoList)
    }
    
    @objc public static func zim(_ zim: ZIM, conversationTotalUnreadMessageCountUpdated totalUnreadMessageCount: UInt32) {
        ZIMKitCore.shared.zim(zim, conversationTotalUnreadMessageCountUpdated: totalUnreadMessageCount)
    }
    
    // MARK: - Group
    
    
    // MARK: - Message
    @objc public static func zim(_ zim: ZIM, receivePeerMessage messageList: [ZIMMessage], fromUserID: String) {
        ZIMKitCore.shared.zim(zim, receivePeerMessage: messageList, fromUserID: fromUserID)
    }
    
    @objc public static func zim(_ zim: ZIM, receiveGroupMessage messageList: [ZIMMessage], fromGroupID: String) {
        ZIMKitCore.shared.zim(zim, receiveGroupMessage: messageList, fromGroupID: fromGroupID)
    }
    
    @objc public static func zim(_ zim: ZIM, receiveRoomMessage messageList: [ZIMMessage], fromRoomID: String) {
        ZIMKitCore.shared.zim(zim, receiveRoomMessage: messageList, fromRoomID: fromRoomID)
    }
    
    @objc public static func zim(_ zim: ZIM, messageRevokeReceived messageList: [ZIMRevokeMessage]) {
        ZIMKitCore.shared.zim(zim, messageRevokeReceived: messageList)
    }
    
    @objc public static func zim(_ zim: ZIM, groupMemberStateChanged state: ZIMGroupMemberState, event: ZIMGroupMemberEvent, userList: [ZIMGroupMemberInfo], operatedInfo: ZIMGroupOperatedInfo, groupID: String) {
        ZIMKitCore.shared.zim(zim, groupMemberStateChanged: state, event: event, userList: userList, operatedInfo: operatedInfo, groupID: groupID)
    }
                         
    @objc public static func zim(_ zim: ZIM, messageReactionsChanged reactions: [ZIMMessageReaction]) {
        ZIMKitCore.shared.zim(zim, messageReactionsChanged: reactions)
    }
    
    @objc public static func updateNewestFriendApplication(from list: [ZIMFriendApplicationInfo]) {
        ZIMKitCore.shared.updateNewestFriendApplication(from: list)
    }
    
    @objc public static func zim(_ zim: ZIM, messageReceiptChanged infos: [ZIMMessageReceiptInfo]) {
        ZIMKitCore.shared.zim(zim, messageReceiptChanged: infos)
    }
}
