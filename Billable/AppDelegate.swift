//
//  AppDelegate.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        setRootVC()
        return true
    }

    private func setRootVC() {
        if let employee = loggedInEmployee() {
            let summaryVC = UIStoryboard(
                name: SummaryViewController.storyboardName,
                bundle: Bundle.init(for: SummaryViewController.self))
                .instantiateViewController(
                    withIdentifier: SummaryViewController.storyboardID) as! SummaryViewController
            let viewModel = SummaryViewModel(employee: employee)
            summaryVC.viewModel = viewModel
            let navController = UINavigationController(rootViewController: summaryVC)
            window?.rootViewController = navController
        } else {
            let controller = UIStoryboard(name: LoginViewController.storyboardName, bundle: Bundle.init(for: LoginViewController.self)).instantiateViewController(withIdentifier: LoginViewController.storyboardID)
            window?.rootViewController = controller
        }
    }

    private func loggedInEmployee() -> Employee? {
        guard let employeedId = UserDefaults.standard.string(forKey: signedInKey) else {
            return nil
        }
        guard let dictionary = LoginServiceWrapper().getData(with: allEmployeeFilename, directory: employeeDirectory) as? JSON,
            let employeeArray = dictionary["employees"] as? [JSON] else {
                return nil
        }
        let employees = employeeArray.compactMap { Employee(dictionary: $0) }
        let employee = employees.first(where: { employeedId == $0.id })
        return employee
    }
}

