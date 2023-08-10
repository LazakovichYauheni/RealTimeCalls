//
//  KeychainHelper.swift
//  WaveForm
//
//  Created by Eugeni Lazakovich on 4.08.23.
//

import Foundation

public final class KeychainHelper {
    public static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ data: Data, service: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
        
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    func read(service: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
}
