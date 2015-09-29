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
  
  // MARK: Types
  
  struct  PropertyKey {
    static let topTextKey = "topText"
    static let bottomTextKey = "topText"
    static let imageKey = "topText"
    static let memedImageKey = "topText"
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
    aCoder.encodeObject(topText, forKey: PropertyKey.topTextKey)
    aCoder.encodeObject(bottomText, forKey: PropertyKey.bottomTextKey)
    aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
    aCoder.encodeObject(memedImage, forKey: PropertyKey.memedImageKey)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    let topText = aDecoder.decodeObjectForKey(PropertyKey.topTextKey) as! String
    let bottomText = aDecoder.decodeObjectForKey(PropertyKey.bottomTextKey) as! String
    let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as! UIImage
    let memedImage = aDecoder.decodeObjectForKey(PropertyKey.memedImageKey) as! UIImage
    self.init(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
  }
  
}
