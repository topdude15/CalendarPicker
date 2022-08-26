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


import Foundation


let weekDayNumbers = [
    Weekday.Sunday: 0,
    Weekday.Monday: 1,
    Weekday.Tuesday: 2,
    Weekday.Wednesday: 3,
    Weekday.Thursday: 4,
    Weekday.Friday: 5,
    Weekday.Saturday: 6
]

/// The Weekday enum is used to more easily track weekdays across use cases.  The weekDayNumbers dictionary allows us to sort any list of weekdays in order without any need for Dates or other identifiers.
enum Weekday: String, CustomStringConvertible, CaseIterable, Codable {
    case Sunday
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    
    var description: String {
        switch self {
        case .Sunday: return "Su"
        case .Monday: return "M"
        case .Tuesday: return "Tu"
        case .Wednesday: return "W"
        case .Thursday: return "Th"
        case .Friday: return "F"
        case .Saturday: return "Sa"
        }
    }
    
    func sortWeekdays(weekdays: [Weekday]) -> [Weekday] {
        return weekdays.sorted(by: { (weekDayNumbers[$0] ?? 7) < (weekDayNumbers[$1] ?? 7)})
    }
}


@available(iOS 15, *)
func getCurrentWeek() -> [String] {
    var weekdays: [String] = []
    var startOfWeek = Date.now.startOfWeek()
    guard let endOfWeek = Date().endOfWeek else { return [] }
    while startOfWeek <= endOfWeek - 1 {
        let dayComponents = Calendar.current.dateComponents([.month, .day], from: startOfWeek)
        let formattedString = "\(dayComponents.month!)/\(dayComponents.day!)"
        weekdays.append(formattedString)
        startOfWeek = Calendar.current.date(byAdding: .day, value: 1, to: startOfWeek)!
    }
    return weekdays
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self).date!
    }
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
}
