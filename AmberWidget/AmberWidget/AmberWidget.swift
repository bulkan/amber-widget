import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  let amberApi = AmberApi()
  
  func placeholder(in context: Context) -> AmberWidgetEntry {
    AmberWidgetEntry(date: Date(), currentPrice: 22.13)
  }
  
  func getSnapshot(in context: Context, completion: @escaping (AmberWidgetEntry) -> ()) {
    let entry = AmberWidgetEntry(date: Date(), currentPrice: 22.12)
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      let currentDate = Date()
      let currentPrice = try await amberApi.getCurrentSitePrice()?.perKwh ?? 0.0
      let entry = AmberWidgetEntry(date: currentDate, currentPrice: currentPrice)
      let entries: [AmberWidgetEntry] = [entry]
      
      let reloadDate = Calendar.current.date(byAdding: .minute,
                                              value: 5,
                                              to: currentDate)!
      let timeline = Timeline(entries: entries, policy: .after(reloadDate))
      completion(timeline)
    }
  }
}

struct AmberWidgetEntry: TimelineEntry {
  let date: Date
  let currentPrice: Float
}

struct AmberWidgetEntryView : View {
  var entry: Provider.Entry
  
  @AppStorage("apiKey", store: UserDefaults(suiteName: "group.dev.bulkan.api")) private var apiKey: String = ""
  
  var body: some View {
    VStack {
      
      if apiKey.isEmpty {
        Text("Please configure api key in app")
      } else {
        Text("\(entry.currentPrice, specifier: "%.0f")c/kWh")
          .fontWeight(.heavy)
          .font(.system(size: 25))
          .foregroundStyle(.white)
        
        Text("\(entry.date)")
          .font(.system(size: 12))
      }
    }
  }
}

struct AmberWidget: Widget {
  let kind: String = "Amber Widget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        AmberWidgetEntryView(entry: entry)
          .containerBackground(Color("brandPrimary"), for: .widget)
      } else {
        AmberWidgetEntryView(entry: entry)
          .padding()
          .background(Color("brandPrimary"))
      }
    }
//    .supportedFamilies([.systemSmall])
    .configurationDisplayName("Amber Widget")
    .description("Displays current electricy price")
  }
}

#Preview(as: .systemSmall) {
  AmberWidget()
} timeline: {
  AmberWidgetEntry(date: .now, currentPrice: 20.1)
}

