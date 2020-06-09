//
//  TimeDisplayView.swift
//  Recipe Book
//
//  Created by Clarence Siew on 9/6/20.
//  Copyright © 2020 Clarence Siew. All rights reserved.
//

import SwiftUI

struct TimeUnitDisplayView: View {
    var timeQuantity: Int?
    var timeUnit: TimeUnit?
    
    var body: some View {
        VStack {
            Text(String(timeQuantity ?? 0)).font(.title)
            Text(TimeUnitSupplemental.getDescription(unit: timeUnit ?? .seconds)).font(.caption)
        }
        .frame(idealWidth: 72, maxWidth: 72)
        .padding(.all, 8)
        .background(Color(UIColor.secondarySystemFill))
        .cornerRadius(8)
    }
}

struct TimeDisplayView: View {
    @State var timeInSeconds: Int = 0
    @State var days: Int = 0
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    var body: some View {
        HStack {
            TimeUnitDisplayView(timeQuantity: days, timeUnit: .days)
            TimeUnitDisplayView(timeQuantity: hours, timeUnit: .hours)
            TimeUnitDisplayView(timeQuantity: minutes, timeUnit: .minutes)
            TimeUnitDisplayView(timeQuantity: seconds, timeUnit: .seconds)
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            (self.days, self.hours, self.minutes, self.seconds) = TimeDetection.secondsToDHMS(seconds: self.timeInSeconds)
        }
    }
}

struct TimeDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        TimeDisplayView()
    }
}
