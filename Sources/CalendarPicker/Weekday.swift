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
