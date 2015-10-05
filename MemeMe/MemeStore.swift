//
//  MemeStore.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class MemeStore: NSObject {
  var savedMemes: [Meme]!
  static let sharedStore = MemeStore()

  //  MARK: Archiving Paths
  static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("savedMemes")
  static let UserDefaultsKey = "savedMemes"

  private override init(){
    super.init()
//    let path = MemeStore.ArchiveURL.path!
//    if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [Meme] {
//      self.savedMemes = data
//    } else {
//      self.savedMemes = [Meme]()
//    }
    // Read from NSUserDefaults
    let defaults = NSUserDefaults.standardUserDefaults()
    let data = defaults.objectForKey(MemeStore.UserDefaultsKey) as! NSData
    self.savedMemes = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Meme]


  }
  
  func save() -> Bool {
//    let success = NSKeyedArchiver.archiveRootObject(savedMemes, toFile: MemeStore.ArchiveURL.path!)
//    if !success {
//      print("Failed to save memes...")
//    }
//    
    // Write to NSUserDefaults
    let data = NSKeyedArchiver.archivedDataWithRootObject(savedMemes)
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject(data, forKey: MemeStore.UserDefaultsKey)
    return true
  }
  
  func deleteMeme(atIndex index:Int) -> Bool {
    savedMemes.removeAtIndex(index)
    return save()
  }

  func deleteMeme(meme: Meme) -> Bool {
    guard let index = savedMemes.indexOf(meme) else{ return false }
    return deleteMeme(atIndex: index)
  }

  func addMeme(meme: Meme) -> Bool {
    savedMemes.append(meme)
    return save()
  }

  func isFirstMeme() -> Bool {
    return self.savedMemes.isEmpty
  }

  func deleteAll() -> Bool{
    savedMemes.removeAll()
    return save()
  }

  func swapMemes(first: Int, second: Int) {
    swap(&savedMemes[first], &savedMemes[second])
  }
}
