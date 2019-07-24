//
//  LoginViewController.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    static var storyboardName: String = "Login"
    static var storyboardID: String {
        return String(describing: self)
    }
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var employeeIdTextField: UITextField!

    var viewModel: LoginViewModel = LoginViewModel()
    private var disposal = Disposal()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupTextFields()
        observeViewModelOutputs()
    }

    private func setupTextFields() {
        passwordTextField.delegate = self
        employeeIdTextField.delegate = self
    }

    private func observeViewModelOutputs() {
        viewModel.outputs.loginSuccessful.observe { [weak self] (employee) in
            if let employee = employee {
                self?.loginSuccessful(employee: employee)
            }
        }.add(to: &disposal)
        viewModel.outputs.errorMessage.observe { [weak self] (message) in
            if let message = message {
                self?.showAlert(title: nil, message: message)
            }
        }.add(to: &disposal)
    }

    private func loginSuccessful(employee: Employee) {
        let summaryVC = UIStoryboard(
            name: SummaryViewController.storyboardName,
            bundle: Bundle.init(for: SummaryViewController.self))
            .instantiateViewController(
                withIdentifier: SummaryViewController.storyboardID) as! SummaryViewController
        let viewModel = SummaryViewModel(employee: employee)
        summaryVC.viewModel = viewModel
        let navController = UINavigationController(rootViewController: summaryVC)
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = navController
    }

    @IBAction func loginTapped(_ sender: UIButton) {
        login()
    }

    fileprivate func login() {
        guard let id = employeeIdTextField.text,
            let password = passwordTextField.text else { return }
        if id.isEmpty {
            showAlert(title: nil, message: LOGINxTEXT.emptyEmployeeId.description)
            return
        }
        if password.isEmpty {
            showAlert(title: nil, message: LOGINxTEXT.emptyPassword.description)
            return
        }
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet.init(charactersIn: id)) {
            showAlert(title: nil, message: LOGINxTEXT.invalidEmployeeId.description)
            return
        }
        viewModel.login(id: id, password: password)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == employeeIdTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            login()
        }
        return true
    }
}

extension UIViewController {
    func showAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
