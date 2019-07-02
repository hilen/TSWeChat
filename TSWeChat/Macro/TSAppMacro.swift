//
//  AppMacro.swift
//  TSWeChat
//
//  Created by Hilen on 1/8/17.
//  Copyright © 2016 Hilen. All rights reserved.
//

//delegate 代理
let TSAppDelegate = UIApplication.shared.delegate as! AppDelegate

// 沙盒文档路径
let kSandDocumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
