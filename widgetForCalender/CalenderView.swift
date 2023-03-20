//
//  ContentView.swift
//  widgetForCalender
//
//  Created by MD SAZID HASAN DIP on 2023/03/15.
//

import SwiftUI
import CoreData
import WidgetKit

struct CalenderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfCalndarWithPrefixDays as CVarArg, Date().endOfMonth as CVarArg),
        animation: .default)
    private var days: FetchedResults<Day>
    
    
    var body: some View {
        NavigationView {
            VStack {
               CalenderHeaderView()
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days){ day in
                        if day.date!.monthInt != Date().monthInt {
                            Text("")
                        }else {
                            Text(day.date!.formatted(.dateTime.day()))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .foregroundColor(day.didStudy ? .orange: .secondary)
                                .background(
                                    Circle()
                                        .foregroundColor(.orange.opacity(day.didStudy ? 0.3: 0.0))
                                )
                                .onTapGesture {
                                    if day.date!.dayInt < Date().dayInt {
                                        day.didStudy.toggle()
                                        print(day.didStudy)
                                        do {
                                            try viewContext.save()
                                            WidgetCenter.shared.reloadTimelines(ofKind: "swiftCal")
                                            print("\(day.date!.dayInt) now studied")
                                            
                                        }catch {
                                            print("date could not be saved")
                                        }
                                    }else {
                                        print("Can not study in the future.")
                                    }
                                }
                        }
                        
                        
                    }
                }
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
            .onAppear{
                if days.isEmpty {
                    createMonthDays(for: .now.startOfPreviousMonth)
                    createMonthDays(for: .now)
                    print(Date().dayInt)
                } else if days.count < 10 {
                    createMonthDays(for: .now)
                }
            }
        }
        
        
   
        
        
    }
    
    
    func createMonthDays(for date: Date) {
        for dayOffset in 0..<date.numberOfDaysInMonth {
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: date.startOfMonth)
            newDay.didStudy = false
        }
        do {
            try viewContext.save()
        }catch {
            print("date could not be saved")
        }
    }
}
    
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            CalenderView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }

