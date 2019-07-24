//
//  LoginService.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation
import UIKit

typealias JSON = [String: Any]

enum LoginError: Error {
    case incorrectPassword
}

protocol LoginService: Storage {
    func login(employeedId: String, password: String) -> Result<Employee, LoginError>
}

final class LoginServiceWrapper: LoginService {
    func login(employeedId: String, password: String) -> Result<Employee, LoginError> {
        let newEmployee = Employee(id: employeedId, password: password)
        guard let dictionary = getData(with: allEmployeeFilename, directory: employeeDirectory) as? JSON,
        let employeeArray = dictionary["employees"] as? [JSON] else {
            //First time access
            save(employee: newEmployee, to: [])
            return .success(newEmployee)
        }
        let employees = employeeArray.compactMap { Employee(dictionary: $0) }
        let employee = employees.first(where: { employeedId == $0.id })
        if employee == nil {
            // New employee
            save(employee: newEmployee, to: employeeArray)
            return .success(newEmployee)
        }
        if employee?.password != password {
            return .failure(LoginError.incorrectPassword)
        }
        return .success(employee!)
    }

    private func save(employee: Employee, to allEmployees: [JSON]) {
        var employees = allEmployees
        employees.append(employee.toObject())
        try? store(dictionary: ["employees": employees], filename: allEmployeeFilename, directory: employeeDirectory)
    }
}
