//
//  MemeStore.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
Singleton that manages the persistence of the set of Memes the user has created and saved.
*/
class MemeStore: NSObject {
  /// Singleton pattern shared instance
  static let sharedStore = MemeStore()

  /// The array of saved memes
  var savedMemes: [Meme]!
  

  static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("savedMemes")
  static let UserDefaultsKey = "savedMemes"

  //MARK:- Initialization
  private override init(){
    super.init()
    let defaults = NSUserDefaults.standardUserDefaults()
    if let data = defaults.objectForKey(MemeStore.UserDefaultsKey) as? NSData {
      self.savedMemes = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Meme]
    } else {
      self.savedMemes = [Meme]()
    }


  }
  
  //MARK:- Persistence

  /// queue guard
  private let saveQueue = dispatch_queue_create(
    "com.metafeatapps.MemeMe.store", DISPATCH_QUEUE_CONCURRENT
  )

  private var userInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
  }
  
  /// Saves memes by writing `savedMemes` to NSUserDefaults. Runs in background
  /// on the "UserInitiated" Queue
  func save() {
    dispatch_barrier_async(saveQueue) {
      dispatch_async(self.userInitiatedQueue) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self.savedMemes)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: MemeStore.UserDefaultsKey)
      }
    }
  }
  
  /// Deletes a meme by index **without saving**
  func deleteMeme(atIndex index:Int) {
    dispatch_barrier_async(saveQueue) {
      self.savedMemes.removeAtIndex(index)
    }
  }

  /// Removes all memes. Will be called if you pass the run argument `DeleteAllMemesOnStartup`
  func deleteAll() {
    dispatch_barrier_async(saveQueue) {
      self.savedMemes.removeAll()
      self.save()
    }
  }
  
  /// Is this the first meme to be created?
  func isFirstMeme() -> Bool {
    return self.savedMemes.isEmpty
  }
  
  /// Adds a meme by appending it to `savedMemes`
  func addMeme(meme: Meme) {
    dispatch_barrier_async(saveQueue) {
      self.savedMemes.append(meme)
      self.save()
    }
  }

  /// Given two indices, swaps the memes at those indices in `savedMemes` **without** saving.
  func swapMemes(first: Int, second: Int) {
    dispatch_barrier_async(saveQueue) {
      swap(&self.savedMemes[first], &self.savedMemes[second])
    }
  }
}
