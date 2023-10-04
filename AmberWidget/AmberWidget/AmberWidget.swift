import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), emoji: "😀")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), emoji: "😀")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
    
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, emoji: "😀")
      entries.append(entry)
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let emoji: String
}

struct AmberWidgetEntryView : View {
  @State private var currentPrice:Float = 0.0;
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      Text("\(currentPrice, specifier: "%.0f")c/kWh")
        .fontWeight(.heavy)
        .font(.system(size: 36))
    }
    .onAppear {
      Task {
        currentPrice = try await AmberApi.getCurrentSitePrice()?.perKwh ?? 0.0
        //            isCurrentPsriceLoading = false
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
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        AmberWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  AmberWidget()
} timeline: {
  SimpleEntry(date: .now, emoji: "😀")
  SimpleEntry(date: .now, emoji: "🤩")
}
