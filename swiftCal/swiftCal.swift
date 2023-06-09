//
//  swiftCal.swift
//  swiftCal
//
//  Created by MD SAZID HASAN DIP on 2023/03/17.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    var dayFetchRequest: NSFetchRequest<Day> {
        let request = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfCalndarWithPrefixDays as CVarArg, Date().endOfMonth as CVarArg)
        return request
    }
    let viewContext = PersistenceController.shared.container.viewContext
    func placeholder(in context: Context) -> CalendarEntry {
        
        CalendarEntry(date: Date(), days: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (CalendarEntry) -> ()) {
        print("Getting Snapshot")
        do {
          let days =  try viewContext.fetch(dayFetchRequest)
            print(days.debugDescription)
            let entry = CalendarEntry(date: Date(), days: days)
            print(entry.date.debugDescription)
            completion(entry)
        }catch{
            print("Widget failed to handle the fetch request in widget snapshot")
        }
        

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        do {
          let days =  try viewContext.fetch(dayFetchRequest)
            let entry = CalendarEntry(date: Date(), days: days)
            let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
            completion(timeline)
        }catch{
            print("Widget failed to handle the fetch request in widget snapshot")
        }
        
    }
}

struct CalendarEntry: TimelineEntry {
    let date: Date
    let days: [Day]
}

struct swiftCalEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry
    var body: some View {
        switch family{
        
        case .systemMedium:
            MediumCalenderView(entry: entry,streakValue: calculateStreakValue())
                .onAppear{
                    print(calculateStreakValue())
                }
        case .accessoryCircular:
            EmptyView()
        case .accessoryInline:
            Label("Streak - \(calculateStreakValue()) days", systemImage: "swift")
                .onAppear{
                    print(calculateStreakValue())
                }
        case .accessoryRectangular:
            EmptyView()
        default:
            EmptyView()
        }
        

    }
    
    func calculateStreakValue() -> Int {
        guard !entry.days.isEmpty else {return 0}
        print("printing days",entry.days)
        let noFutureDays = entry.days.filter{
            $0.date!.dayInt <= Date().dayInt}
        
        var streakCounter = 0
        for day in noFutureDays.reversed() {
            if day.didStudy {
                streakCounter = streakCounter + 1
                
            }else {
        
                if day.date!.dayInt != Date().dayInt {
                    break
                }
            }
        }
        
        print("Strick counter for widget: \(streakCounter)")
        return streakCounter
        
    }
}

struct swiftCal: Widget {
    let kind: String = "swiftCal"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            swiftCalEntryView(entry: entry)
        }
        .configurationDisplayName("Swift Study Calender")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

struct swiftCal_Previews: PreviewProvider {
    static var previews: some View {
        swiftCalEntryView(entry: CalendarEntry(date: Date(), days: []))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


//MARK: - UI Components for widget sizes

private struct MediumCalenderView:View {
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var entry:CalendarEntry
    var streakValue: Int
    var body: some View{
        HStack {
            VStack {
                
                Text("\(streakValue)")
                    .font(.system(size: 70, design: .rounded))
                    .foregroundColor(.orange)
                    .onAppear{
                        print(streakValue)
                        print(entry.days)
                    }
                Text("day streak")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            }
            VStack {
                CalenderHeaderView(font: .caption)
                LazyVGrid(columns: columns,spacing: 7) {
                    ForEach(entry.days) { day in
                        if day.date!.monthInt != Date().monthInt {
                            Text("")
                        }else {
                            Text(day.date!.formatted(.dateTime.day()))
                                .font(.caption2)
                                .bold()
                                .frame(maxWidth: .infinity)
                                .foregroundColor( day.didStudy ? .orange : .secondary)
                                .background{
                                    Circle()
                                        .foregroundColor(.orange.opacity(day.didStudy ? 0.3 : 0.0))
                                        .scaleEffect(1.5)
                                }

                        }
                        
                    }
                }
            }
            .padding(.leading,6)
        }
        .padding()
        .onAppear{
            print(streakValue)
        }
    }
        
}
