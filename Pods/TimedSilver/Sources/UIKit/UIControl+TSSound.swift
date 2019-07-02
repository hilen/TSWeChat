//
//  UIControl+TSSound.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/10/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIControl {
    fileprivate struct AssociatedKeys {
        static var ts_soundKey = "ts_soundKey"
    }
    
    /**
     Add sound to UIControl
     
     - parameter name:         music name
     - parameter controlEvent: controlEvent
     */
    public func ts_addSoundName(_ name: String, forControlEvent controlEvent: UIControl.Event)  {
        let oldSoundKey: String = "\(controlEvent)"
        let oldSound: AVAudioPlayer = self.ts_sounds[oldSoundKey]!
        let selector = NSSelectorFromString("play")
        self.removeTarget(oldSound, action: selector, for: controlEvent)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: "AVAudioSessionCategoryAmbient"))
            // Find the sound file.
            guard let soundFileURL = Bundle.main.url(forResource: name, withExtension: "") else {
                assert(false, "File not exist")
                return
            }
            
            let tapSound: AVAudioPlayer = try! AVAudioPlayer(contentsOf: soundFileURL)
            let controlEventKey: String = "\(controlEvent)"
            var sounds: [AnyHashable: Any] = self.ts_sounds
            sounds[controlEventKey] = tapSound
            tapSound.prepareToPlay()
            self.addTarget(tapSound, action: selector, for: controlEvent)
        }
        catch _ {}
    }
    
    /// AssociatedObject for UIControl
    var ts_sounds: Dictionary<String, AVAudioPlayer> {
        get {
            if let sounds = objc_getAssociatedObject(self, &AssociatedKeys.ts_soundKey) {
                return sounds as! Dictionary<String, AVAudioPlayer>
            }
            
            var sounds = Dictionary() as Dictionary<String, AVAudioPlayer>
            sounds = self.ts_sounds
            return sounds
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.ts_soundKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}


