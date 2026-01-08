//
//  L10n.swift
//  ZIMKitCommon
//
//  Created by Kael Ding on 2022/8/2.
//

import Foundation

public func L10n(_ key : String, tableName: String = "ZIMKit", _ args: CVarArg...) -> String {
    let format = ZIMKitLocalizeManager.shared.localizedString(key: key, tableName: tableName)
    return String(format: format, arguments: args)
}

