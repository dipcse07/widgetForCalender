//
//  calWidget2.swift
//  calWidget2
//
//  Created by MD SAZID HASAN DIP on 2023/04/07.
//

import WidgetKit
import SwiftUI
import CoreData
struct Provider: TimelineProvider {
    
    let viewContextForCal2 = PersistenceController.shared.container.viewContext
    var dayFetchRequest: NSFetchRequest<Day> {
        let request = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Day.date, ascending: true)]
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        Date().startOfCalndarWithPrefixDays as CVarArg,
                                        Date().endOfMonth as CVarArg)
        return request
    }
    func placeholder(in context: Context) -> Cal2Entry {
        Cal2Entry(date: Date(), days: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (Cal2Entry) -> ()) {
        
//        @FetchRequest(
//            sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
//            predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfCalndarWithPrefixDays as CVarArg, Date().endOfMonth as CVarArg),
//            animation: .default)
        

        //            animation: .default)
        do {
            let days = try viewContextForCal2.fetch(dayFetchRequest)
            print(days)
            let entry = Cal2Entry(date: Date(), days: days)
            completion(entry)
        }catch{
            fatalError("Widget Failed to fetch days in snapshot")
        }

    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        do {
            let days = try viewContextForCal2.fetch(dayFetchRequest)
            let entry = Cal2Entry(date: Date(), days: days)
            let timeline = Timeline(entries: [entry], policy: .after(.now.endOfDay))
            completion(timeline)
        }catch{
            fatalError("Widget Failed to fetch days in snapshot")
        }

        
        
    }
}

struct Cal2Entry: TimelineEntry {
    let date: Date
    let days:[Day]
}

struct calWidget2EntryView : View {
    var entry: Provider.Entry

    var body: some View {
        MediumCalenderView2(entry: entry, streakValue: calculateStreakValue())
    }
    
    func calculateStreakValue() -> Int {
        guard !entry.days.isEmpty else {return 0}
//        print(days)
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
        
        return streakCounter
        
    }
}

struct calWidget2: Widget {
    let kind: String = "calWidget2"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            calWidget2EntryView(entry: entry)
        }
        .configurationDisplayName("Cal2")
        .description("Widget for Cal2.")
        .supportedFamilies([.systemMedium])
    }
}

struct calWidget2_Previews: PreviewProvider {
    static var previews: some View {
        calWidget2EntryView(entry: Cal2Entry(date: Date(), days: []))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


private struct MediumCalenderView2:View {
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    var entry: Provider.Entry
    var streakValue: Int
    var body: some View{
        HStack {
            VStack {
                
                Text("\(streakValue)")
                    .font(.system(size: 70, design: .rounded))
                    .foregroundColor(.orange)
                    .onAppear{
                        print(streakValue)
//                        print(entry.days)
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
