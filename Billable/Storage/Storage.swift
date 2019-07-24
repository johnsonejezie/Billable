//
//  Storage.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

let allEmployeeFilename = "allemployees"
let identifier = "com.johnsonejezie.Billable"
let employeeDirectory = "employees"
let timeCardDirectory = "timecarddirectory"
let signedInKey = "com.johnsonejezie.Billable.signedInKey"

protocol Storage {
    func getData(with filename: String, directory: String) -> Any?
    func store(dictionary: [String: Any], filename: String, directory: String) throws
}

extension Storage {
    func getData(with filename: String, directory: String) -> Any? {
        let directoryURL = create(directory: directory)
        let fullPath = directoryURL.appendingPathComponent(filename).appendingPathExtension("plist")
        print(fullPath)
        let dictionary = NSDictionary(contentsOf: fullPath)
        return dictionary
    }

    func store(dictionary: [String: Any], filename: String, directory: String) throws {
        let fileExtension = "plist"
        let directoryURL = create(directory: directory)
        let fullPath = directoryURL.appendingPathComponent(filename)
        print(fullPath)
        do {
            let data = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
            try data.write(to: fullPath.appendingPathExtension(fileExtension))
        } catch {
            print(error.localizedDescription)
            print(error.localizedDescription)
        }

    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func create(directory: String) -> URL {
        let dataPath = getDocumentsDirectory().appendingPathComponent(directory)
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: dataPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        return dataPath
    }
}

final class StorageWrapper: Storage {}
