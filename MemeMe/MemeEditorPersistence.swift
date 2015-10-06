//
//  MemeEditorPersistence.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit
/**
Save memes
*/
extension MemeEditorViewController {
  //  TODO: see if can refactor Meme to make properties optional, so this can be DRYed
  
  /// Creates and persists the current meme, or updates it if it was already persisted
  func save(memedImage: UIImage) {
    if var newMeme = meme {
      //  update meme from UI values
      newMeme.topText = topTextField.text!
      newMeme.bottomText = bottomTextField.text!
      newMeme.image = imageView.image!
      newMeme.memedImage = memedImage
      MemeStore.sharedStore.save()
    } else {
      //Create a new meme from UI values
      let meme = Meme(
        topText: topTextField.text!,
        bottomText: bottomTextField.text!,
        image: imageView.image!,
        memedImage: memedImage
      )
      MemeStore.sharedStore.addMeme(meme)
    }
  }
}
