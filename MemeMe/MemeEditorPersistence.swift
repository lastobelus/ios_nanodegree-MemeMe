//
//  MemeEditorPersistence.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit
extension MemeEditorViewController {
  func save(memedImage: UIImage) {
    //Create the meme
    let meme = Meme(
      topText: topTextField.text!,
      bottomText: bottomTextField.text!,
      image: imageView.image!,
      memedImage: memedImage
    )
    MemeStore.sharedStore.addMeme(meme)
  }
}
