import WidgetKit
import SwiftUI

private let appGroupId = "group.com.example.exampleApp"

/// Chọn ảnh (do Flutter render) theo cỡ widget:
/// small / lock accessory = 1 tuần, medium = 2 tuần, large = tháng.
private func imageKey(for family: WidgetFamily) -> String {
    switch family {
    case .systemMedium:
        return "cal_twoWeeks"
    case .systemLarge, .systemExtraLarge:
        return "cal_month"
    default:
        return "cal_week"
    }
}

private func loadImage(_ key: String) -> UIImage? {
    guard let defaults = UserDefaults(suiteName: appGroupId),
          let path = defaults.string(forKey: key) else { return nil }
    return UIImage(contentsOfFile: path)
}

struct CalendarEntry: TimelineEntry {
    let date: Date
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CalendarEntry {
        CalendarEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> Void) {
        completion(CalendarEntry(date: Date()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalendarEntry>) -> Void) {
        let now = Date()
        // Làm mới đầu giờ tiếp theo (widget hiển thị ảnh mới nhất app đã render).
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: now) ?? now
        completion(Timeline(entries: [CalendarEntry(date: now)], policy: .after(next)))
    }
}

struct CalendarWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        content.widgetContainerBackground()
    }

    @ViewBuilder
    private var content: some View {
        if let ui = loadImage(imageKey(for: family)) {
            Image(uiImage: ui)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Text("Mở app để đồng bộ lịch")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(8)
        }
    }
}

extension View {
    /// iOS 17 yêu cầu containerBackground; giữ trong suốt để dùng nền của ảnh.
    @ViewBuilder
    func widgetContainerBackground() -> some View {
        if #available(iOS 17.0, *) {
            self.containerBackground(.clear, for: .widget)
        } else {
            self
        }
    }
}

struct CalendarWidget: Widget {
    let kind = "CalendarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CalendarWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Lịch")
        .description("Lịch + sự kiện theo tuần/tháng")
        .supportedFamilies([
            .systemSmall, .systemMedium, .systemLarge,
            .accessoryRectangular, .accessoryCircular,
        ])
    }
}

@main
struct CalendarWidgetBundle: WidgetBundle {
    var body: some Widget {
        CalendarWidget()
    }
}
