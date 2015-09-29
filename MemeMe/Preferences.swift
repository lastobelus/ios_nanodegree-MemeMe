//
//  Preferences.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class Preferences {
  static let instance = Preferences()
  
  // MARK: Keys
  enum  Keys:String {
    case
    ExpandImageTopPastStatusBarWhenTyping
    func key() -> String {
      return rawValue
    }
    func bool() -> Bool {
      let key = rawValue
      let value = NSUserDefaults.standardUserDefaults().boolForKey(key)
      return value
    }
  }
  
  let expandImageTopPastStatusBarWhenTyping:Bool

  init() {

    if let defaultPrefsFile = NSBundle.mainBundle().URLForResource("Settings" , withExtension: "plist") {
      if let defaultPrefs = NSDictionary(contentsOfURL: defaultPrefsFile) as? [String : AnyObject] {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.registerDefaults(defaultPrefs)
        
      }
    }
  
    expandImageTopPastStatusBarWhenTyping = Keys.ExpandImageTopPastStatusBarWhenTyping.bool()

  }
  

}

