//
//  StreakView.swift
//  widgetForCalender
//
//  Created by MD SAZID HASAN DIP on 2023/03/17.
//

import SwiftUI
import CoreData

struct StreakView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", Date().startOfMonth as CVarArg, Date().endOfMonth as CVarArg),
        animation: .default)
    private var days: FetchedResults<Day>
    
    @State private var streakValue = 0
    var body: some View {
        VStack {
            Text("\(streakValue)")
                .font(.system(size:200, weight: .semibold, design: .rounded))
                .foregroundColor(streakValue > 0 ? .orange : .pink)
            Text ("Current Streak")
                .font(.title)
                .bold()
                .foregroundColor(.secondary)
        }
        .offset(y: -50)
        .onAppear{
            streakValue = calculateStreakValue()
        }
    }
    
    func calculateStreakValue() -> Int {
        guard !days.isEmpty else {return 0}
//        print(days)
        let noFutureDays = days.filter{
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

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView()
    }
}
