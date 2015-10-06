//
//  Preferences.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
A class for managing Application settings. Currently manages a single preference:
expandImageTopPastStatusBarWhenTyping

TODO: Could move lots of magic numbers & constants here
*/
class Preferences {
  static let instance = Preferences()
  
  //MARK: Keys
  enum  Keys:String {
    case
    ExpandImageTopPastStatusBarWhenTyping
    func key() -> String {
      return rawValue
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
  
    //    MARK:- Values
    expandImageTopPastStatusBarWhenTyping = NSUserDefaults.standardUserDefaults().boolForKey(Keys.ExpandImageTopPastStatusBarWhenTyping.key())

  }
  

}

