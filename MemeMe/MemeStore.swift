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
  var savedMemes: [Meme]! {
    get {
      var memes: [Meme]!
      dispatch_sync(saveQueue) {
        memes = self._savedMemes
      }
      return memes
    }
  }
  var _savedMemes: [Meme]!


  static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
  static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("savedMemes")
  static let UserDefaultsKey = "savedMemes"

  //MARK:- Initialization
  private override init(){
    super.init()
    let defaults = NSUserDefaults.standardUserDefaults()
    self.saveQueue = dispatch_queue_create(
      "com.metafeatapps.MemeMe.store", DISPATCH_QUEUE_CONCURRENT
    )
    if let data = defaults.objectForKey(MemeStore.UserDefaultsKey) as? [AnyObject] {
      dispatch_sync(self.saveQueue) {
        self._savedMemes = extractValuesFromPropertyListArray(data)
      }
    } else {
      dispatch_sync(self.saveQueue) {
        self._savedMemes = [Meme]()
      }
    }
  }
  
  //MARK:- Persistence

  /// queue guard
  //RADAR: when I used let & created the queue here, it worked on simulator
  // but caused an EXC_BAD_ACCESS on my device. I was unable to figure out why
  private var saveQueue: dispatch_queue_t!

  private var userInitiatedQueue: dispatch_queue_t {
    return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
  }
  
  /// Saves memes by writing `savedMemes` to NSUserDefaults. Runs in background
  /// on the "UserInitiated" Queue
  func save() {
    dispatch_barrier_async(saveQueue) {
      dispatch_async(self.userInitiatedQueue) {
        saveValuesToDefaults(self._savedMemes, key: MemeStore.UserDefaultsKey)
      }
    }
  }
  
  /// Deletes a meme by index **without saving**
  func deleteMeme(atIndex index:Int) {
    dispatch_sync(saveQueue) {
      self._savedMemes.removeAtIndex(index)
    }
  }

  /// Removes all memes. Will be called if you pass the run argument `DeleteAllMemesOnStartup`
  func deleteAll() {
    dispatch_sync(saveQueue) {
      self._savedMemes.removeAll()
    }
    save()
  }
  
  /// Is this the first meme to be created?
  func isFirstMeme() -> Bool {
    var empty: Bool!
    dispatch_sync(saveQueue) {
      empty = self._savedMemes.isEmpty
    }
    return empty
  }
  
  /// Adds a meme by appending it to `savedMemes`
  func addMeme(meme: Meme) {
    dispatch_sync(saveQueue) {
      self._savedMemes.append(meme)
    }
    save()
  }

  /// Given two indices, swaps the memes at those indices in `savedMemes` **without** saving.
  func swapMemes(first: Int, second: Int) {
    dispatch_sync(saveQueue) {
      swap(&self._savedMemes[first], &self._savedMemes[second])
    }
  }
}
