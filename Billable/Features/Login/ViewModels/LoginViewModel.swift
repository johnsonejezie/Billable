//
//  LoginViewModel.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

protocol LoginViewModelInputs {
    func login(id: String, password: String)
}

protocol LoginViewModelOutputs {
    var errorMessage: Observable<String?> { get }
    var loginSuccessful: Observable<Employee?> { get }
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
    var inputs: LoginViewModelInputs { return self }
    var outputs: LoginViewModelOutputs { return self }
    var errorMessage: Observable<String?> = Observable(nil)
    var loginSuccessful: Observable<Employee?> = Observable(nil)
    let service: LoginService

    init(service: LoginService = LoginServiceWrapper()) {
        self.service = service
    }

    func login(id: String, password: String) {
        let result = service.login(employeedId: id, password: password)
        switch result {
        case .failure:
            errorMessage.value = "Incorrect password"
        case .success(let employee):
            UserDefaults.standard.set(employee.id, forKey: signedInKey)
            loginSuccessful.value = employee
        }
    }
}

enum LOGINxTEXT: CustomStringConvertible, CaseIterable {
    case employeePlaceholder
    case passwordPlaceholder
    case login
    case emptyPassword
    case emptyEmployeeId
    case invalidEmployeeId

    var description: String {
        var key = ""
        switch self {
        case .employeePlaceholder:
            key = "EMPLOYEE_ID_TEXTFIELD_PLACEHOLDER"
        case .passwordPlaceholder:
            key = "PASSWORD_TEXTFIELD_PLACEHOLDER"
        case .login:
            key = "LOGIN"
        case .emptyPassword:
            key = "EMPTY_PASSWORD"
        case .emptyEmployeeId:
            key = "EMPTY_EMPLOYEE_ID"
        case .invalidEmployeeId:
            key = "INVALID_EMPLOYEE_ID"
        }
        return NSLocalizedString(key, tableName: "Login",
                                 bundle: Bundle(for: LoginViewController.self), comment: "")
    }
}
