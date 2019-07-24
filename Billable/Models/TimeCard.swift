//
//  TimeCard.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

class TimeCard: Equatable {
    static func == (lhs: TimeCard, rhs: TimeCard) -> Bool {
        return lhs.employeeId == rhs.employeeId &&
            lhs.date == rhs.date &&
            lhs.start == rhs.start &&
            lhs.end == rhs.end
    }

    var employeeId: String
    var rate: Double
    var project: String
    var date: Date
    var start: Date
    var end: Date
    var hour: Int

    private let timeFormat: String = "HH:mm"
    private let dateFormat: String = "yyyy-MM-dd"

    var startTimeAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: start)
    }

    var endTimeAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: end)
    }

    var dateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    convenience init?(dictionary: [String: Any]) {
        guard let employeeId = dictionary["employeeId"] as? String,
        let rate = dictionary["rate"] as? Double,
        let project = dictionary["project"] as? String,
        let dateString = dictionary["date"] as? String,
        let startDateString = dictionary["start"] as? String,
            let hour = dictionary["hour"] as? Int,
            let endDateString = dictionary["end"] as? String else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from: dateString)
        self.init(
            employeeId: employeeId,
            rate: rate,
            project: project,
            date: date!,
            start: formatter.date(from: startDateString)!,
            end: formatter.date(from: endDateString)!,
            hour: hour)
    }

    init(
        employeeId: String,
        rate: Double,
        project: String,
        date: Date,
        start: Date,
        end: Date,
        hour: Int
        ) {
        self.employeeId = employeeId
        self.rate = rate
        self.project = project
        self.date = date
        self.start = start
        self.end = end
        self.hour = hour
    }

    func toObject() -> [String: Any] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: date)
        return [
            "employeeId": employeeId,
            "rate": rate,
            "project": project,
            "date": dateString,
            "hour": hour,
            "start": formatter.string(from: start),
            "end": formatter.string(from: end)
        ]
    }
}
