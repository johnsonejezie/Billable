//
//  CreateTimeCardViewModel.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

protocol CreateTimeCardViewModelInputs {
    func createTimeCard(date: Date, endTime: Date, startTime: Date, rate: Double, project: String)
}

protocol CreateTimeCardViewModelOutputs {
    var createdTimecard: Observable<TimeCard?> { get }
    var projects: [String] { get }
    var title: String { get }
    var dateFormat: String { get }
    var timeFormat: String { get }
}

protocol CreateTimeCardViewModelType {
    var inputs: CreateTimeCardViewModelInputs { get }
    var outputs: CreateTimeCardViewModelOutputs { get }
}

final class CreateTimeCardViewModel: CreateTimeCardViewModelType, CreateTimeCardViewModelOutputs, CreateTimeCardViewModelInputs {
    var dateFormat: String = "yyyy-MM-dd"

    var timeFormat: String = "HH:mm"

    var projects: [String] =  ["Google", "Facebook", "Amazon", "Intel", "Apple", "Microsoft", "Dangote"]

    var title: String = "Time Card"

    var inputs: CreateTimeCardViewModelInputs { return self }
    var outputs: CreateTimeCardViewModelOutputs { return self }
    var createdTimecard: Observable<TimeCard?> = Observable(nil)

    let employee: Employee
    var timeCard: TimeCard?
    init(employee: Employee, timeCard: TimeCard? = nil) {
        self.employee = employee
        self.timeCard = timeCard
    }

    func createTimeCard(date: Date, endTime: Date, startTime: Date, rate: Double, project: String) {
        let hour = endTime.hours(from: startTime)
        timeCard = TimeCard(employeeId: employee.id, rate: rate, project: project, date: date, start: startTime, end: endTime, hour: hour)
        createdTimecard.value = timeCard
    }


}

extension Date {
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
}
