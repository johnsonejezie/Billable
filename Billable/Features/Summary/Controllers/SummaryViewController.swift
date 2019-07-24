//
//  SummaryViewController.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!

    static var storyboardName: String = "Summary"
    static var storyboardID: String {
        return String(describing: self)
    }
    var viewModel: SummaryViewModel!
    private var disposal = Disposal()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        setupBarItems()
        title = "Summary"
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(BillableHourTableViewCell.Nib, forCellReuseIdentifier: BillableHourTableViewCell.identifier)
        tableView.register(TotalBillableHourTableViewCell.Nib, forCellReuseIdentifier: TotalBillableHourTableViewCell.identifier)
        observeViewModelOutputs()
    }

    private func observeViewModelOutputs() {
        viewModel.outputs.reload.observe { [weak self] yes in
            if yes {
                self?.tableView.reloadData()
            }
        }.add(to: &disposal)
    }

    private func setupBarItems() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTimeCard(_:)))
        navigationItem.rightBarButtonItem = add
        let logout = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout(_:)))
        navigationItem.leftBarButtonItem = logout
    }

    @objc func logout(_ sender: Any) {
        let loginVC = UIStoryboard(
            name: LoginViewController.storyboardName,
            bundle: Bundle.init(for: LoginViewController.self))
            .instantiateViewController(
                withIdentifier: LoginViewController.storyboardID) as! LoginViewController
        let viewModel = LoginViewModel()
        loginVC.viewModel = viewModel
        (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = loginVC
    }

    @objc func addTimeCard(_ sender: Any) {
        let controller = UIStoryboard(name: CreateTimeCardViewController.storyboardName, bundle: Bundle.init(for: CreateTimeCardViewController.self)).instantiateViewController(withIdentifier: CreateTimeCardViewController.storyboardID) as! CreateTimeCardViewController
        controller.createdTimeCardBlock = { [weak self] card in
            self?.viewModel.inputs.add(card: card)
        }
        let viewModel = CreateTimeCardViewModel(employee: self.viewModel.employee)
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SummaryViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.groupedTimeCards.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groupedTimeCards[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BillableHourTableViewCell.identifier) as! BillableHourTableViewCell
        let card = viewModel.groupedTimeCards[indexPath.section][indexPath.row]
        cell.configure(card: card)
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.headerTitle(index: section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: TotalBillableHourTableViewCell.identifier) as! TotalBillableHourTableViewCell
        cell.configure(total: viewModel.totalHours(index: section))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let card = viewModel.groupedTimeCards[indexPath.section][indexPath.row]
            viewModel.delete(card: card)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard(name: CreateTimeCardViewController.storyboardName, bundle: Bundle.init(for: CreateTimeCardViewController.self)).instantiateViewController(withIdentifier: CreateTimeCardViewController.storyboardID) as! CreateTimeCardViewController
         let timeCard = viewModel.groupedTimeCards[indexPath.section][indexPath.row]
        controller.createdTimeCardBlock = { [weak self] card in
            print(timeCard.dateAsString)
            print(card.dateAsString)
            self?.viewModel.inputs.update(newCard: card, oldCard: timeCard)
        }
        let viewModel = CreateTimeCardViewModel(employee: self.viewModel.employee, timeCard: timeCard)
        controller.viewModel = viewModel
        navigationController?.pushViewController(controller, animated: true)
    }
}
