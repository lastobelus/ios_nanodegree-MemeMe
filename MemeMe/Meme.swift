//
//  Meme.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class Meme: NSObject, NSCoding {
  
  //  MARK: Properties
  var topText: String
  var bottomText: String
  var image: UIImage
  var memedImage: UIImage
  
  // MARK: Keys
  
  enum  Keys:String {
    case
      topText,
      bottomText,
      image,
      memedImage
    func key() -> String {
      return self.rawValue
    }
  }
  
  init(
    topText: String,
    bottomText: String,
    image: UIImage,
    memedImage: UIImage) {
      self.topText = topText
      self.bottomText = bottomText
      self.image = image
      self.memedImage = memedImage
      
      super.init()
  }

  //  MARK: NSCoding
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(topText, forKey: Keys.topText.key())
    aCoder.encodeObject(bottomText, forKey: Keys.bottomText.key())
    aCoder.encodeObject(image, forKey: Keys.image.key())
    aCoder.encodeObject(memedImage, forKey: Keys.memedImage.key())
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let topText = aDecoder.decodeObjectForKey(Keys.topText.key()) as! String
    let bottomText = aDecoder.decodeObjectForKey(Keys.bottomText.key()) as! String
    let image = aDecoder.decodeObjectForKey(Keys.image.key()) as! UIImage
    let memedImage = aDecoder.decodeObjectForKey(Keys.memedImage.key()) as! UIImage
    self.init(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
  }
  
}
