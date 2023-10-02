import SwiftUI

struct AmberWidgetTabView: View {
  var body: some View {
    TabView {
      HomeView()
        .tabItem {
          Image(systemName: "house")
          Text("Home")
        }
      SettingsView()
        .tabItem {
          Image(systemName: "gear")
          Text("Settings")
        }
    }
    .accentColor(Color("brandPrimary"))
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AmberWidgetTabView()
    }
}
