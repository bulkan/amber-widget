import SwiftUI

struct HomeView: View {
  @AppStorage("siteId", store: UserDefaults(suiteName: "group.dev.bulkan.api")) private var siteId: String = ""
  
  @State private var currentPrice: Float = 0;
  @State private var isCurrentPriceLoading = true
  
  var onResetApiKey: (() -> Void)?
  
  let amberApi = AmberApi()
  
  var body: some View {
    NavigationView {
      VStack {
        Button("Reset API key") {
          self.onResetApiKey?()
        }
        .fontWeight(.light)
        .font(.system(size: 10))
        
        Text(siteId)
          .fontWeight(.light)
          .font(.system(size: 10))
          .offset(y: 50)

        Group {
          if isCurrentPriceLoading {
            ProgressView()
              .progressViewStyle(.circular)
          }
          else {
            Text("\(currentPrice, specifier: "%.0f")/kWh")
              .fontWeight(.heavy)
              .font(.system(size: 36))
          }
        }.offset(y: 150)
        
      }
      .offset(y: -200)
      .navigationTitle("⚡️ Amber Widget")
      .navigationBarTitleDisplayMode(.large)
    }

    .onAppear {
      Task {
        currentPrice = try await amberApi.getCurrentSitePrice()?.perKwh ?? 0.0
        isCurrentPriceLoading = false
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
