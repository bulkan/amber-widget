import SwiftUI


struct DataService  {
  @AppStorage("siteId", store: UserDefaults(suiteName: "group.dev.bulkan.api"))
    private var siteId: String = ""
  
  @AppStorage("apiKey", store: UserDefaults(suiteName: "group.dev.bulkan.api")) 
    private var apiKey = ""

  
  func updateApiKey(apiKey: String) {
    self.apiKey = apiKey
  }
  
  func getApiApi() -> String {
    return apiKey
  }
}
