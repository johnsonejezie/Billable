//
//  CreateTimeCardViewController.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import UIKit

class CreateTimeCardViewController: UIViewController {

    static var storyboardName: String = "Create"
    static var storyboardID: String {
        return String(describing: self)
    }

    @IBOutlet var projectTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    @IBOutlet var endTimeTextField: UITextField!
    @IBOutlet var startTimeTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var rateTextField: UITextField!

    var date: Date?
    var startDate: Date?
    var endDate: Date?

    var viewModel: CreateTimeCardViewModel!
    private var disposal = Disposal()

    var createdTimeCardBlock: ((TimeCard) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        observeViewModelOutputs()
        populate()
    }

    private func populate() {
        if let card = viewModel.timeCard {
            rateTextField.text = "\(card.rate)"
            endTimeTextField.text = card.endTimeAsString
            endDate = card.end
            startDate = card.start
            date = card.date
            startTimeTextField.text = card.startTimeAsString
            dateTextField.text = card.dateAsString
            projectTextField.text = card.project
        }
    }

    private func observeViewModelOutputs() {
        viewModel.createdTimecard.observe { [weak self] (timeCard) in
            if let card = timeCard {
                self?.createdTimeCardBlock?(card)
                self?.navigationController?.popViewController(animated: true)
            }
        }.add(to: &disposal)
    }

    @IBAction func textFieldEditing(_ sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.locale = Locale(identifier: "en_GB")
        if sender.tag == 1000 {
            datePickerView.maximumDate = Date()
            datePickerView.datePickerMode = UIDatePicker.Mode.date
        } else {
            if let end = endDate {
                datePickerView.maximumDate = end
            } else if let start = startDate {
                datePickerView.minimumDate = start
            }
            datePickerView.datePickerMode = UIDatePicker.Mode.time
        }
        sender.inputView = datePickerView
        datePickerView.tag = sender.tag
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }

    @IBAction func projectTextFieldEditing(_ sender: UITextField) {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        sender.inputView = pickerView
    }

    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        if sender.tag == 1000 {
            dateFormatter.dateFormat = viewModel.outputs.dateFormat
            dateTextField.text = dateFormatter.string(from: sender.date)
            self.date = sender.date
        } else if sender.tag == 1001 {
            dateFormatter.dateFormat = viewModel.outputs.timeFormat
            self.startDate = sender.date
            startTimeTextField.text = dateFormatter.string(from: sender.date)
        } else {
            dateFormatter.dateFormat = viewModel.outputs.timeFormat
            self.endDate = sender.date
            endTimeTextField.text = dateFormatter.string(from: sender.date)
        }
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        guard let date = self.date,
        let endDate = self.endDate,
        let startDate = self.startDate,
        let project = projectTextField.text,
        let rate = rateTextField.text else { return }
        guard let rateInDouble = Double(rate) else { return }
        guard !project.isEmpty else {
            return
        }
        viewModel.createTimeCard(date: date, endTime: endDate, startTime: startDate, rate: rateInDouble, project: project)

    }
}

extension CreateTimeCardViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.outputs.projects.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.outputs.projects[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        projectTextField.text = viewModel.outputs.projects[row]
    }
}
