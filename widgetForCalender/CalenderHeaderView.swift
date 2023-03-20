//
//  CalenderHeaderView.swift
//  widgetForCalender
//
//  Created by MD SAZID HASAN DIP on 2023/03/20.
//

import SwiftUI

struct CalenderHeaderView: View {
    private let daysOfWeek = ["Su","Mo","Tu","Wd","Th","Fr","St"]
    var font:Font = .body
    
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self){
                daysOfWeek in
                Text(daysOfWeek)
                    .font(font)
                    .fontWeight(.black)
                    .foregroundColor(.orange)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct CalenderHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderHeaderView()
    }
}
