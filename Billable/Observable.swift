//
//  Observable.swift
//  Billable
//
//  Created by Johnson Ejezie on 21/07/2019.
//  Copyright © 2019 Johnson Ejezie. All rights reserved.
//

import Foundation

public final class Observable<T> {

    public typealias Observer = (T) -> Void

    private var observers: [Int: Observer] = [:]
    private var uniqueID = (0...).makeIterator()

    public var value: T {
        didSet {
            observers.values.forEach { $0(value) }
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    public func observe(_ emitCurrentValue: Bool = true, _ observer: @escaping Observer) -> Disposable {
        guard let id = uniqueID.next() else { fatalError("There should always be a next unique id") }

        observers[id] = observer
        if emitCurrentValue {
            observer(value)
        }

        let disposable = Disposable { [weak self] in
            self?.observers[id] = nil
        }

        return disposable
    }

    public func removeAllObservers() {
        observers.removeAll()
    }
}

public typealias Disposal = [Disposable]

public final class Disposable {

    private let dispose: () -> Void

    init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }

    deinit {
        dispose()
    }

    public func add(to disposal: inout Disposal) {
        disposal.append(self)
    }
}
