//
//  MemeEditorPersistence.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit
extension MemeEditorViewController {
  //  TODO: see if can refactor Meme to make properties optional, so this can be DRYed
  func save(memedImage: UIImage) {
    if let meme = self.meme {
      //  update meme from UI values
      meme.topText = topTextField.text!
      meme.bottomText = bottomTextField.text!
      meme.image = imageView.image!
      meme.memedImage = memedImage
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
