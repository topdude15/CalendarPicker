//
//  WeeklyCalendarPickerView.swift
//  WeekSchedule
//
//  Created by Trevor Rose on 7/21/22.
//

import SwiftUI

/// The WeekdayCalendarPickerView allows for a selection of one or multiple days of the week.
/// It pulls its data from the Weekday enum, which contains both cases and CustomStringConvertable string descriptions.
///  \n
struct WeekdayCalendarPickerView: View {
    @Binding var buttonsSelected: [Weekday]
    
    let daysOfWeek: [String] = getCurrentWeek()
    var currentDay: Int = 0
    
    var canSelectMultiple: Bool
    var showDates: Bool
    
    var body: some View {
        
        HStack {
            
            // Create a new button for each case of the Weekday enum
            ForEach(Array(Weekday.allCases.enumerated()), id: \.element) { index, element in
                VStack(alignment: .center, spacing: 0) {
                    if (showDates) {
                        Text(daysOfWeek[index])
                            .padding(.bottom, 5)
                            .foregroundColor(Color.secondary)
                            .font(.footnote)
                    }
                    Button {
                        // If the view can be used to select multiple days, append / filter the array of Weekday elements to add / remove elements
                        if (canSelectMultiple) {
                            if (buttonsSelected.contains(element)) {
                                buttonsSelected = buttonsSelected.filter() {$0 != element}
                            } else {
                                buttonsSelected.append(element)
                            }
                            // If the view cannot be used to select multiple days, just set the array of Weekday elements to equal the selected day.  This way, only one day is selected at a time
                        } else {
                            self.buttonsSelected = [element]
                        }
                    } label: {
                        Text(element.description)
                            .ignoresSafeArea()
                            .foregroundColor(.primary)
                    }
                    // Give the buttons infinite space to spread out the entire width of the screen
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 12)
                    // Switch the background color of the button based on sfelection status
                    .background(buttonsSelected.contains(element) ? Color.blue : Color("DayNotSelected"))
                    // Clip background to circle
                    .clipShape(Circle())
                    // This keeps the buttons from all getting pressed at once when used in a Form element
                    .buttonStyle(.borderless)
                }
            }
        }
    }
}

struct WeeklyCalendarPickerView_Previews: PreviewProvider {
    static var previews: some View {
        WeekdayCalendarPickerView(buttonsSelected: .constant([]), canSelectMultiple: true, showDates: true)
    }
}
