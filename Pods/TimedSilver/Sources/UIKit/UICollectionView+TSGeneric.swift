//
//  UICollectionView+TSGeneric.swift
//  TimedSilver
//  Source: https://github.com/hilen/TimedSilver
//
//  Created by Hilen on 8/22/16.
//  Copyright © 2016 Hilen. All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    // MARK: - Cell register and reuse
    /**
     Register cell nib
     
     - parameter aClass: class
     */
    func ts_registerCellNib<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: name)
    }
    
    /**
     Register cell class
     
     - parameter aClass: class
     */
    func ts_registerCellClass<T: UICollectionViewCell>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forCellWithReuseIdentifier: name)
    }
    
    /**
     Dequeue reusable cell
     
     - parameter aClass:    class
     - parameter indexPath: indexPath
     
     - returns: cell
     */
    func ts_dequeueReusableCell<T: UICollectionViewCell>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withReuseIdentifier: name, for: indexPath) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
    
    // MARK: - Header register and reuse
    /**
     Register header nib
     
     - parameter aClass: class
     */
    func ts_registerHeaderNib<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }
    
    /**
     Register header nib
     
     - parameter aClass: class
     */
    func ts_registerHeaderClass<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }
    
    /**
     Dequeue reusable header
     
     - parameter aClass:    class
     - parameter indexPath: indexPath
     
     - returns: cell
     */
    func ts_dequeueReusableHeader<T: UICollectionReusableView>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: name,
            for: indexPath) as? T else {
                fatalError("\(name) is not registed")
        }
        return view
    }
    
    // MARK: - Footer register and reuse
    /**
     Register header nib
     
     - parameter aClass: class
     */
    func ts_registerFooterNib<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        let nib = UINib(nibName: name, bundle: nil)
        self.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name)
    }
    
    /**
     Register header nib
     
     - parameter aClass: class
     */
    func ts_registerFooterClass<T: UICollectionReusableView>(_ aClass: T.Type) {
        let name = String(describing: aClass)
        self.register(aClass, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: name)
    }
    
    /**
     Dequeue reusable header
     
     - parameter aClass:    class
     - parameter indexPath: indexPath
     
     - returns: cell
     */
    func ts_dequeueReusableFooter<T: UICollectionReusableView>(_ aClass: T.Type, forIndexPath indexPath: IndexPath) -> T! {
        let name = String(describing: aClass)
        guard let view = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: name,
            for: indexPath) as? T else {
                fatalError("\(name) is not registed")
        }
        return view
    }
}
