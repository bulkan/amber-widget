import Foundation
import Security

class KeychainManager {
  private static let account = "amberApiKey"
  private static let service = "dev.bulkan.amberApiKey"
  
  static func storeCredentialsInKeychain(apiKey: String) {
    if let apiKeyData = apiKey.data(using: .utf8) {
      let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecAttrService as String: service,
        kSecValueData as String: apiKeyData
      ]

      let status = SecItemAdd(query as CFDictionary, nil)
      
      if status != errSecSuccess {
        print("Error storing amber apiKey in keychain: \(status)")
      }
    }
  }
  
  static func getApiKeyFromKeychain() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else {
      return ""
    }
    guard status == errSecSuccess else {
      return ""
    }
    
    guard
      let existingItem = item as? [String: Any],
      let valueData = existingItem[kSecValueData as String] as? Data,
      let apiKey = String(data: valueData, encoding: .utf8)
      else {
      return ""
    }
    
 
    return apiKey
  }
  
  static func deleteApiKey()  {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      return
    }
  }
}
