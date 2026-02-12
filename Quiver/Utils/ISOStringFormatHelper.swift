//
//  ISOStringFormatHelper.swift
//  Quiver
//
//  Created by Michael on 15/01/2026.
//

import Foundation

struct DateTime {
    let date: String
    let time: String
}

func dateAndTime(isoDateString: String) -> DateTime {
    var parsedDate: Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]

        return isoFormatter.date(from: isoDateString)
    }

    var formattedDate: String {
        guard let date = parsedDate else { return "Invalid date" }

        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let suffix = daySuffix(from: day)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"

        let dateString = dateFormatter.string(from: date)
        return "\(day)\(suffix) \(dateString)"
    }

    var formattedTime: String {
        guard let date = parsedDate else { return "Invalid time" }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter.string(from: date)
    }

    func daySuffix(from day: Int) -> String {
        switch day {
        case 11...13: return "th"
        default:
            switch day % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }

    return DateTime(date: formattedDate, time: formattedTime)
}
