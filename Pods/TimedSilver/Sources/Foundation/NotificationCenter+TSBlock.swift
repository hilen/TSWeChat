//
//  NSNotificationCenter+TSBlock.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 12/18/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

//https://gist.github.com/brentdax/64845dc0b3fec0a27d87


import Foundation

public extension NotificationCenter {
    /**
     NSNotificationCenter with closure
     
     - parameter observer: observer
     - parameter aName:    name
     - parameter anObject: object
     - parameter queue:    queue
     - parameter handler:  the handler
     
     - returns: AnyObject
     */
    @discardableResult
    func ts_addObserver<T: AnyObject>(_ observer: T, name aName: String?, object anObject: AnyObject?, queue: OperationQueue? = OperationQueue.main, handler: @escaping (_ observer: T, _ notification: Notification) -> Void) -> AnyObject {
        let observation = addObserver(forName: aName.map { NSNotification.Name(rawValue: $0) }, object: anObject, queue: queue) { [unowned observer] note in
            handler(observer, note)
        }
        
        TSObservationRemover(observation).makeRetainedBy(observer)
        
        return observation
    }
}

private class TSObservationRemover: NSObject {
    let observation: NSObjectProtocol
    
    init(_ obs: NSObjectProtocol) {
        observation = obs
        super.init()
    }
    
    func makeRetainedBy(_ owner: AnyObject) {
        ts_observationRemoversForObject(owner).add(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observation)
    }
}

private var TSObservationRemoverKey: UnsafeRawPointer? = nil

private func ts_observationRemoversForObject(_ object: AnyObject) -> NSMutableArray {
    if TSObservationRemoverKey == nil {
        withUnsafePointer(to: &TSObservationRemoverKey) { pointer in
            TSObservationRemoverKey = UnsafeRawPointer(pointer)
        }
    }
    
    var retainedRemovers = objc_getAssociatedObject(object, TSObservationRemoverKey!) as! NSMutableArray?
    if retainedRemovers == nil {
        retainedRemovers = NSMutableArray()
        objc_setAssociatedObject(object, TSObservationRemoverKey!, retainedRemovers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    return retainedRemovers!
}




