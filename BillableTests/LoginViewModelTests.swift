//
//  LoginViewModelTests.swift
//  BillableTests
//
//  Created by Johnson Ejezie on 23/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import XCTest
@testable import Billable

class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!

    override func setUp() {
        //mock service if need be
        viewModel = LoginViewModel()
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

    func testSuccessLogin() {
        let employeeId = "2222"
        let password = "password"
        login(id: employeeId, password: password)
        XCTAssertNotNil(viewModel.loginSuccessful.value)
        XCTAssertEqual(employeeId, viewModel.loginSuccessful.value?.id)
    }

    func testFailedLogin() {
        let employeeId = "4444"
        let password = "password"
        login(id: employeeId, password: password)
        XCTAssertNotNil(viewModel.loginSuccessful.value)
        XCTAssertEqual(employeeId, viewModel.loginSuccessful.value?.id)
        login(id: employeeId, password: "peder")
        XCTAssertEqual(viewModel.errorMessage.value, "Incorrect password")
    }

    private func login(id: String, password: String) {
        viewModel.login(id: id, password: password)
    }

}
