//
//  CMServiceContext.swift
//  CMPattern
//
//  Created by fei on 2026/3/28.
//

// 介绍：场景内的**服务上下文**：按类型 `provide` / `acquire` / `remove`，并为每类型维护一个 `CMObservable`（NSLock 保护）。

import Foundation

// MARK: - Observer token

public final class CMObserverToken: Hashable, @unchecked Sendable {
    fileprivate let id = UUID()

    public static func == (lhs: CMObserverToken, rhs: CMObserverToken) -> Bool { lhs.id == rhs.id }

    public func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

// MARK: - Observable

public final class CMObservable: @unchecked Sendable {
    public typealias Observer = (Any?) -> Void
    public typealias ValueSetter = (Any?) -> Any?
    public typealias Setter = ValueSetter

    private weak var context: CMServiceContext?
    private let typeKey: ObjectIdentifier
    private var observers: [CMObserverToken: Observer] = [:]
    private let lock = NSLock()

    fileprivate init(type: AnyClass, context: CMServiceContext) {
        typeKey = ObjectIdentifier(type)
        self.context = context
    }

    @discardableResult
    public func addObserver(_ observer: @escaping Observer) -> CMObserverToken {
        let token = CMObserverToken()
        lock.lock()
        observers[token] = observer
        lock.unlock()
        return token
    }

    public func removeObserver(_ token: CMObserverToken) {
        lock.lock()
        observers[token] = nil
        lock.unlock()
    }

    public func update(_ setter: @escaping ValueSetter) {
        lock.lock()
        let snapshot = observers
        lock.unlock()

        let current = context?.acquireAny(for: typeKey)
        let updated = setter(current)
        if let newObject = updated as? AnyObject, (current as AnyObject?) !== newObject {
            context?.provideAny(newObject, for: typeKey)
        }
        snapshot.values.forEach { $0(updated) }
    }
}

// MARK: - Service providing protocol

public protocol CMServiceProviding: AnyObject {
    func provide(_ object: AnyObject)
    func acquire<T: AnyObject>(_ type: T.Type) -> T?
    func remove<T: AnyObject>(_ type: T.Type)
    func clear()
    func observe<T: AnyObject>(_ type: T.Type) -> CMObservable?
}

// MARK: - Context

public final class CMServiceContext: CMServiceProviding, @unchecked Sendable {
    private var provisionTable: [ObjectIdentifier: AnyObject] = [:]
    private var observableTable: [ObjectIdentifier: CMObservable] = [:]
    private let lock = NSLock()

    fileprivate func acquireAny(for key: ObjectIdentifier) -> AnyObject? {
        lock.lock()
        defer { lock.unlock() }
        return provisionTable[key]
    }

    fileprivate func provideAny(_ object: AnyObject, for key: ObjectIdentifier) {
        lock.lock()
        defer { lock.unlock() }
        provisionTable[key] = object
    }

    public func provide(_ object: AnyObject) {
        provideAny(object, for: ObjectIdentifier(type(of: object)))
    }

    public func acquire<T>(_ type: T.Type) -> T? where T: AnyObject {
        lock.lock()
        defer { lock.unlock() }
        return provisionTable[ObjectIdentifier(type)] as? T
    }

    public func remove<T>(_ type: T.Type) where T: AnyObject {
        lock.lock()
        defer { lock.unlock() }
        provisionTable[ObjectIdentifier(type)] = nil
    }

    public func clear() {
        lock.lock()
        defer { lock.unlock() }
        provisionTable.removeAll()
        observableTable.removeAll()
    }

    public func observe<T>(_ type: T.Type) -> CMObservable? where T: AnyObject {
        let key = ObjectIdentifier(type)
        lock.lock()
        if let cached = observableTable[key] {
            lock.unlock()
            return cached
        }
        let observable = CMObservable(type: type, context: self)
        observableTable[key] = observable
        lock.unlock()
        return observable
    }
}
