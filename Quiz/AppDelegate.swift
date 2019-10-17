//
//  AppDelegate.swift
//  Quiz
//
//  Created by 이재현 on 2019/10/17.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import UIKit

import SnapKit
import Then
import CGFloatLiteral

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .white
    window.makeKeyAndVisible()

    window.rootViewController = QuizViewController(reactor: QuizViewReactor())
    self.window = window
    
    return true
  }
}

