//
//  Extensions.swift
//  SwiftyTwitterClient
//
//  Created by yuichiro_t on 2015/08/16.
//  Copyright (c) 2015年 yuichiro_t. All rights reserved.
//

import Foundation

extension Optional {
  
  func foreach(f: (T) -> ()) {
    if let this = self {
      f(this)
    }
  }
  
  func getOrElse(defaultValue: T) -> T {
    switch self {
    case let .Some(some): return some
    case .None: return defaultValue
    }
  }
}
