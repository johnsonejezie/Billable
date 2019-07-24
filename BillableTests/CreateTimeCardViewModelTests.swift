//
//  CreateTimeCardViewModel.swift
//  BillableTests
//
//  Created by Johnson Ejezie on 23/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import XCTest
@testable import Billable

class CreateTimeCardViewModelTests: XCTestCase {

    var viewModel: CreateTimeCardViewModel!
    let employee = Employee(id: "3333", password: "pass3333")
    let rawTimecards = [["end": "2019-07-23 20:41:26", "rate": 21.0, "hour": 11, "start": "2019-07-23 09:41:22", "project": "Facebook", "date": "2019-07-22 21:41:14", "employeeId": "22"], ["rate": 3.0, "project": "Facebook", "date": "2019-07-22 21:44:06", "end": "2019-07-23 12:44:00", "hour": 4, "start": "2019-07-23 07:44:10", "employeeId": 2]]

    override func setUp() {
        viewModel = CreateTimeCardViewModel(employee: employee)
    }

    override func tearDown() {
    }

    func testInputs() {
        let inputs = viewModel.inputs
        XCTAssertNotNil(inputs)
    }

    func testOutputs() {
        let outputs = viewModel.outputs
        XCTAssertNotNil(outputs)
    }

    func testCreateTimeCard() {
        let card = TimeCard(dictionary: rawTimecards.first!)!
        viewModel.createTimeCard(date: card.date, endTime: card.end, startTime: card.start, rate: card.rate, project: card.project)
        XCTAssertNotNil(viewModel.outputs.createdTimecard.value)
    }

}
