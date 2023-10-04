import Foundation
import Security

class KeychainManager {
  static func storeCredentialsInKeychain(apiKey: String) {
    if let apiKeyData = apiKey.data(using: .utf8) {
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: "amberApiKey",
        kSecAttrService as String: "amber api key",
        kSecValueData as String: apiKeyData
      ]

      let status = SecItemAdd(query as CFDictionary, nil)
      
      if status != errSecSuccess {
        print("Error storing amber apiKey in keychain: \(status)")
      }
    }
  }
  
  static func getApiKeyFromKeychain() -> String? {
//    var apiKey: String?
    
//    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
//                                kSecAttrServer as String: "amberApiKey",
//                                kSecMatchLimit as String: kSecMatchLimitOne,
//                                kSecReturnAttributes as String: true,
//                                kSecReturnData as String: true]
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: "amberApiKey",
      kSecAttrService as String: "amber api key",
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else {
//      print("err")
      return ""
    }
    guard status == errSecSuccess else {
      print("err")
      return ""
    }
    
    guard
      let existingItem = item as? [String: Any],
      let valueData = existingItem[kSecValueData as String] as? Data,
      let apiKey = String(data: valueData, encoding: .utf8)
      else {
//        throw KeychainWrapperError(type: .unableToConvertToString)
      return ""
    }
    
 
    return apiKey
  }
  
  static func deleteApiKey()  {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: "amberApiKey",
      kSecAttrService as String: "amber api key"
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      return
    }
  }
}
