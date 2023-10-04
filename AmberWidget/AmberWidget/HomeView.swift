import SwiftUI

struct HomeView: View {
  @State private var apiKey = KeychainManager.getApiKeyFromKeychain() ?? "";
  var onResetApiKey: (() -> Void)?
  
  var body: some View {
    NavigationView {
      Button("Reset API key \(apiKey)") {
        self.onResetApiKey?()
      }
      .navigationTitle("🏠 Home")
    }
  }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
      HomeView()
    }
}
