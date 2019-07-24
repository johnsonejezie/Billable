//
//  SummaryViewModel.swift
//  Billable
//
//  Created by Johnson Ejezie on 22/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

protocol SummaryViewModelInputs {
    func add(card: TimeCard)
    func delete(card: TimeCard)
    func update(newCard: TimeCard, oldCard: TimeCard)
    func viewDidLoad()
    func saveData()
}

protocol SummaryViewModelOutputs {
    var groupedTimeCards: [[TimeCard]] { get }
    var reload: Observable<Bool> { get }
    func headerTitle(index: Int) -> String
    func totalHours(index: Int) -> String
}

protocol SummaryViewModelType {
    var inputs: SummaryViewModelInputs { get }
    var outputs: SummaryViewModelOutputs { get }
}

final class SummaryViewModel: SummaryViewModelType, SummaryViewModelInputs, SummaryViewModelOutputs {
    var inputs: SummaryViewModelInputs { return self }
    var outputs: SummaryViewModelOutputs { return self }
    var reload: Observable<Bool> = Observable(false)
    let employee: Employee
    let storage: Storage
    var timeCards = [TimeCard]()
    var groupedTimeCards: [[TimeCard]] = []
    var timeCardKey: String {
        return "\(employee.id)\(employee.password)"
    }

    init(employee: Employee, storage: Storage = StorageWrapper()) {
        self.employee = employee
        self.storage = storage
    }

    func viewDidLoad() {
        fetchTimeCards()
    }

    func add(card: TimeCard) {
        timeCards.append(card)
        parse(cards: timeCards)
        saveData()
        reload.value = true
    }

    func update(newCard: TimeCard, oldCard: TimeCard) {
        if let index = timeCards.firstIndex(of: oldCard) {
            timeCards.remove(at: index)
            timeCards.insert(newCard, at: index)
            parse(cards: timeCards)
            reload.value = true
            saveData()
        }
    }

    func headerTitle(index: Int) -> String {
        return groupedTimeCards[index].first?.project.capitalized ?? ""
    }

    func totalHours(index: Int) -> String {
        let cards = groupedTimeCards[index]
        let total = cards.reduce(0) { $0 + $1.hour }
        return "\(total)"
    }

    func delete(card: TimeCard) {
        if let index = timeCards.firstIndex(of: card) {
            timeCards.remove(at: index)
            saveData()
            parse(cards: timeCards)
        }
    }

    func saveData() {
        let arrayOfDictionary = timeCards.compactMap { $0.toObject() }
        let dictionary = [timeCardKey: arrayOfDictionary]
        try? storage.store(dictionary: dictionary, filename: timeCardKey, directory: timeCardDirectory)
    }

    func fetchTimeCards() {
        guard let data = storage.getData(with: timeCardKey, directory: timeCardDirectory) as? JSON,
        let array = data[timeCardKey] as? [JSON] else { return }
        timeCards = array.compactMap { TimeCard.init(dictionary: $0) }
        parse(cards: timeCards)
        reload.value = true
    }

    private func parse(cards: [TimeCard]) {
        let dictionary = Dictionary(grouping: cards, by: { $0.project })
        var timecards = [[TimeCard]]()
        dictionary.forEach { (key, value) in
            timecards.append(value)
        }
        groupedTimeCards = timecards
    }
}
