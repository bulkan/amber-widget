import SwiftUI

struct AmberWidgetTabView: View {
  @AppStorage("siteId") var siteId: String = ""
  @State private var apiKey = KeychainManager.getApiKeyFromKeychain() ?? "";

  @ViewBuilder
  var body: some View {
    VStack {
      if apiKey.isEmpty {
        SettingsView(onApiKeySaved: self.onApiKeySaved)
      } else {
        HomeView(onResetApiKey: self.onResetApiKey)
      }
    }
  }
  
  func onResetApiKey() {
    KeychainManager.deleteApiKey()
    UserDefaults.standard.removeObject(forKey: "siteId")
    apiKey = ""
    siteId = ""
  }
  
  func onApiKeySaved(newApiKey: String) async {
    apiKey = newApiKey
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AmberWidgetTabView()
  }
}
