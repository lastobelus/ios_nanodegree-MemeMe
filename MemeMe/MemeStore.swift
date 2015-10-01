//
//  MemeStore.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class MemeStore: NSObject {
  var savedMemes = [Meme]()
  static let sharedStore = MemeStore()

  //  MARK: Archiving Paths
  static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("savedMemes")
  
  override init(){
    super.init()
    if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(MemeStore.ArchiveURL.path!) as? [Meme] {
      self.savedMemes = data
    }
  }
  
  func save() -> Bool {
    let success = NSKeyedArchiver.archiveRootObject(savedMemes, toFile: MemeStore.ArchiveURL.path!)
    if !success {
      print("Failed to save memes...")
    }
    
    return success
  }
  
  func deleteMeme(atIndex index:Int) -> Bool {
    savedMemes.removeAtIndex(index)
    return save()
  }
  
  func addMeme(meme: Meme) -> Bool {
    savedMemes.append(meme)
    return save()
  }

  func isFirstMeme() -> Bool {
    return self.savedMemes.isEmpty
  }
}
