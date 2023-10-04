import SwiftUI

struct SettingsView: View {
  enum FocusedField {
    case apiKeyF
  }
  
  @State private var apiKey = "";
  @State private var showingAlert = false
  
  @FocusState private var focusedField: FocusedField?
  
  var onApiKeySaved: ((_ apiKey: String) async -> Void)?

  var body: some View {
    NavigationView {
      VStack {
        Text("You need to set your Amber API key")
          .padding()
          .border(.gray)
        
        Link("Where to get your key", destination: URL(string: "https://app.amber.com.au/developers/documentation/")!)
    
        Form {
          Section(header: Text("Paste below")) {
            TextField("API key", text: $apiKey)
              .focused($focusedField, equals: .apiKeyF)
              .disableAutocorrection(true)
          }
        }
        .onAppear {
          focusedField = .apiKeyF
        }
      }
      .accentColor(Color("brandPrimary"))
      .toolbar {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Button("Save", action: {
            Task {
              await saveApiKey()
            }
          })
            .disabled(apiKey.isEmpty)
        }
      }
      .navigationTitle("⚙️ Settings")
    }
    .navigationBarBackButtonHidden(false)
  }
  
  func saveApiKey() async {
    if !apiKey.isEmpty {
      KeychainManager.storeCredentialsInKeychain(apiKey: apiKey)
      await self.onApiKeySaved?(apiKey)
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
