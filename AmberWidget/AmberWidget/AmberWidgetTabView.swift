import SwiftUI

struct AmberWidgetTabView: View {
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
    .onAppear {
      KeychainManager.deleteApiKey()
    }
  }
    
  func onResetApiKey() {
    KeychainManager.deleteApiKey()
    self.apiKey = ""
  }
  
  func onApiKeySaved() {
    self.apiKey = KeychainManager.getApiKeyFromKeychain() ?? ""
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AmberWidgetTabView()
    }
}
