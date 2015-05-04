//
//  PathManager.swift
//  PathLogger
//
//  Created by Eugen Pirogoff on 28/03/15.
//  Copyright (c) 2015 Eugen Pirogoff. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class PathManager {
  
  var _paths : [Path]
  var _selected : Int
  
  init(){
    self._paths = []
    self._selected = 0
  }
  
  func selectPath(index: Int) -> Path? {
    self._selected = index
    return _paths[index]
  }
  
  func removePath(index: Int) -> Bool {
    self.updateSelected(index)
    if  _paths.count >= index {
      let removedPath = _paths.removeAtIndex(index)
      println("Deleted: \(removedPath)")
      return true
    } else {
      return false
    }
  }
  
  func addPath(new_path : Path) {
    _paths.append(new_path)
  }
  
  func count() -> Int {
    return _paths.count
  }
  
  func save() {
//    let appDel = UIApplication.sharedApplication().delegate as AppDelegate
  }
  
  func load(){
  
  }
  
  private
  
  func updateSelected(removed_at: Int){
    if removed_at <= self._selected {
      self._selected -= 1
    }
  }
  
}