//
//  NSNotificationCenter+Block.swift
//  TSWeChat
//
//  Created by Hilen on 12/18/15.
//  Copyright © 2015 Hilen. All rights reserved.
//

//https://gist.github.com/brentdax/64845dc0b3fec0a27d87


import Foundation

public extension NotificationCenter {
    func addObserver<T: AnyObject>(_ observer: T, name aName: String?, object anObject: AnyObject?, queue: OperationQueue? = OperationQueue.main, handler: @escaping (_ observer: T, _ notification: Notification) -> Void) -> AnyObject {
        let observation = self.addObserver(forName: aName.map { NSNotification.Name(rawValue: $0) }, object: anObject, queue: queue) { [unowned observer] note in
            handler(observer, note)
        }
        
        ObservationRemover(observation).makeRetainedBy(observer)
        
        return observation
    }
}

private class ObservationRemover: NSObject {
    let observation: NSObjectProtocol
    
    init(_ obs: NSObjectProtocol) {
        observation = obs
        super.init()
    }
    
    func makeRetainedBy(_ owner: AnyObject) {
        observationRemoversForObject(owner).add(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observation)
    }
}

private var ObservationRemoverKey: UnsafeRawPointer? = nil

private func observationRemoversForObject(_ object: AnyObject) -> NSMutableArray {
    if ObservationRemoverKey == nil {
        withUnsafePointer(to: &ObservationRemoverKey) { pointer in
            ObservationRemoverKey = UnsafeRawPointer(pointer)
        }
    }
    
    var retainedRemovers = objc_getAssociatedObject(object, ObservationRemoverKey) as! NSMutableArray?
    if retainedRemovers == nil {
        retainedRemovers = NSMutableArray()
        objc_setAssociatedObject(object, ObservationRemoverKey, retainedRemovers, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    return retainedRemovers!
}




