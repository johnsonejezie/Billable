//
//  SummaryViewModelTests.swift
//  BillableTests
//
//  Created by Johnson Ejezie on 24/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import XCTest
@testable import Billable

class SummaryViewModelTests: XCTestCase {

    var viewModel: SummaryViewModel!
    let employee = Employee(id: "3333", password: "pass3333")
    let rawTimecards = [["end": "2019-07-23 20:41:26", "rate": 21.0, "hour": 11, "start": "2019-07-23 09:41:22", "project": "Facebook", "date": "2019-07-22 21:41:14", "employeeId": "22"], ["rate": 3.0, "project": "Facebook", "date": "2019-07-22 21:44:06", "end": "2019-07-23 12:44:00", "hour": 4, "start": "2019-07-23 07:44:10", "employeeId": "2"]]

    override func setUp() {
        viewModel = SummaryViewModel(employee: employee)
        loadData()
    }

    func testInputs() {
        let inputs = viewModel.inputs
        XCTAssertNotNil(inputs)
    }

    func testOutputs() {
        let outputs = viewModel.outputs
        XCTAssertNotNil(outputs)
    }

    func testSaveAndFetchCard() {
        viewModel.timeCards.removeAll()
        XCTAssert(viewModel.timeCards.isEmpty)
        viewModel.inputs.viewDidLoad()
        XCTAssert(!viewModel.timeCards.isEmpty)
    }

    func testAddCard() {
        let newCard = TimeCard.init(dictionary:
            ["end": "2019-08-23 20:41:26", "rate": 302.0, "hour": 5, "start": "2019-08-23 13:41:22", "project": "Facebook", "date": "2019-08-22 21:41:14", "employeeId": "22"]
        )!
        //Confirm new card is not in time card
        XCTAssertFalse(viewModel.timeCards.contains(newCard))
        viewModel.inputs.add(card: newCard)
        XCTAssertTrue(viewModel.timeCards.contains(newCard))
    }

    func testDeleteCard() {
        let cardToDelete = TimeCard.init(dictionary: rawTimecards.first!)!
        viewModel.inputs.delete(card: cardToDelete)
        viewModel.viewDidLoad()
        XCTAssertFalse(viewModel.timeCards.contains(cardToDelete))
    }

    func testUpdateCard() {
        let newCard = TimeCard.init(dictionary:
            ["end": "2019-08-23 20:41:26", "rate": 302.0, "hour": 5, "start": "2019-08-23 13:41:22", "project": "Facebook", "date": "2019-08-22 21:41:14", "employeeId": "22"]
            )!
        let oldCard = viewModel.timeCards.first!
        viewModel.inputs.update(newCard: newCard, oldCard: oldCard)
        viewModel.inputs.viewDidLoad()
        XCTAssertTrue(viewModel.timeCards.contains(newCard))
        XCTAssertFalse(viewModel.timeCards.contains(oldCard))
    }

    func testTotalHour() {
         let cards = rawTimecards.compactMap { TimeCard.init(dictionary: $0 )}
        let totalFacebookHour = cards.reduce(0) { $0 + $1.hour }
        let total = viewModel.totalHours(index: 0)
        XCTAssert(total == "\(totalFacebookHour)")
    }

    func testHeaderTitle() {
        let title = viewModel.headerTitle(index: 0)
        XCTAssert(title.lowercased() == "facebook")
    }

    private func loadData() {
        let cards = rawTimecards.compactMap { TimeCard.init(dictionary: $0 )}
        viewModel.timeCards = cards
        XCTAssertFalse(cards.isEmpty)
        viewModel.inputs.saveData()
        viewModel.viewDidLoad()
    }

    private func clearData() {
        viewModel.timeCards.removeAll()
        viewModel.inputs.saveData()
    }

    override func tearDown() {
        clearData()
    }

}
