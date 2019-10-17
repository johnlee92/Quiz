//
//  BaseViewController.swift
//  Quiz
//
//  Created by 이재현 on 2019/10/17.
//  Copyright © 2019 Jaehyeon Lee. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }
  
  // MARK: Rx
  
  var disposeBag = DisposeBag()
  
  // MARK: Layout Constraints
  
  private(set) var didSetupConstraints = false
  
  override func viewDidLoad() {
    self.view.setNeedsUpdateConstraints()
  }
  
  override func updateViewConstraints() {
    if !self.didSetupConstraints {
      self.prepareConstraints()
      self.didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func prepareConstraints() {
    // Override point
  }
}
