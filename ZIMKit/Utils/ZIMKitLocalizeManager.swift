//
//  ZIMKitLocalizeManager.swift
//  ZIMKit
//
//  Created by Antigravity on 2026/01/08.
//

import Foundation

public class ZIMKitLocalizeManager {
    public static let shared = ZIMKitLocalizeManager()
    
    private var currentLanguage: ZIMKitLanguage?
    
    private init() {}
    
    public func set(language: ZIMKitLanguage) {
        self.currentLanguage = language
    }
    
    internal func localizedString(key: String, tableName: String) -> String {
        let bundle: Bundle
        if let currentLanguage = currentLanguage {
            // First try to find the lproj bundle for the specific language in the ZIMKit bundle
            if let path = Bundle.ZIMKit.path(forResource: currentLanguage.identifier, ofType: "lproj"),
               let langBundle = Bundle(path: path) {
                bundle = langBundle
            } else {
                // Fallback to ZIMKit bundle if lproj not found (should not happen if set up correctly)
                bundle = Bundle.ZIMKit
            }
        } else {
            // Use default behavior (system language)
            bundle = Bundle.ZIMKit
        }
        
        return bundle.localizedString(forKey: key, value: nil, table: tableName)
    }
}
