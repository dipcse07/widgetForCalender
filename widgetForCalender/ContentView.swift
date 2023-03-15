//
//  ContentView.swift
//  widgetForCalender
//
//  Created by MD SAZID HASAN DIP on 2023/03/15.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.date, ascending: true)],
        animation: .default)
    private var days: FetchedResults<Day>
    private let daysOfWeek = ["SU","MO","TU","WD","Th","Fr"]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    ForEach(daysOfWeek, id: \.self){
                        daysOfWeek in
                        Text(daysOfWeek)
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                    ForEach(days){
                        day in
                        Text(day.date!.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .foregroundColor(day.didStudy ? .orange: .secondary)
                            .background(
                            Circle()
                                .foregroundColor(.orange.opacity(day.didStudy ? 0.3: 0.0))
                            )
                    }
                }
                Spacer()
            }
            .navigationTitle(Date().formatted(.dateTime.month(.wide)))
            .padding()
            
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
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
