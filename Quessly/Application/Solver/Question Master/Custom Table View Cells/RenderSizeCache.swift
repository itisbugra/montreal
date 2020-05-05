//
//  RenderSizeCache.swift
//  Quessly
//
//  Created by Buğra Ekuklu on 4.05.2020.
//  Copyright © 2020 Quessly. All rights reserved.
//

import UIKit

class RenderSizeCache {
  static let shared = RenderSizeCache()
  
  private var cache = [String : CGFloat]()
  
  func renderSize(forHTML HTML: String) -> CGFloat? {
    return cache[HTML]
  }
  
  func set(renderSize size: CGFloat, forHTML HTML: String) {
    cache[HTML] = size
  }
  
  func flush() {
    cache.removeAll()
  }
}
