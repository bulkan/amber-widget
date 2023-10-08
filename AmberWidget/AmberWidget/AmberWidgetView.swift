import SwiftUI

struct AmberWidgetView: View {
  @AppStorage("siteId", store: UserDefaults(suiteName: "group.dev.bulkan.api")) private var siteId: String = ""
  @AppStorage("apiKey", store: UserDefaults(suiteName: "group.dev.bulkan.api")) private var apiKey = ""
  
  @ViewBuilder
  var body: some View {
    VStack {
      if apiKey.isEmpty {
        SettingsView()
      } else {
        HomeView(onResetApiKey: self.onResetApiKey)
      }
    }
  }
  
  func onResetApiKey() {
//    KeychainManager.deleteApiKey()
//    let store = UserDefaults(suiteName: "group.dev.bulkan.api")
//    store?.removeObject(forKey: "siteId")
//    store?.removeObject(forKey: "apiKey")
    apiKey = ""
    siteId = ""
  }
  
  func onApiKeySaved(newApiKey: String) async {
//    UserDefaults(suiteName: "group.dev.bulkan.api")?.set(apiKey, forKey: "apiKey")
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    AmberWidgetView()
  }
}
