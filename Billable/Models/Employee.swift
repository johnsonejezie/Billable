//
//  Employee.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

class Employee: Equatable {
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.id == rhs.id
    }

    let id: String
    let password: String

    init(id: String, password: String) {
        self.id = id
        self.password = password
    }

    convenience init?(dictionary: JSON) {
        guard let id = dictionary["id"] as? String,
            let password = dictionary["password"] as? String else  { return nil }
        self.init(id: id, password: password)
    }

    func toObject() -> JSON {
        return [
            "id": id,
            "password": password
        ]
    }
}
