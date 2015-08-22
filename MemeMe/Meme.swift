//
//  Meme.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class Meme {
  let topText: String
  let bottomText: String
  let image: UIImage
  let memedImage: UIImage
  
  init(
    topText: String,
    bottomText: String,
    image: UIImage,
    memedImage: UIImage) {
      self.topText = topText
      self.bottomText = bottomText
      self.image = image
      self.memedImage = memedImage
  }
}
