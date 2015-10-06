//
//  Meme.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

/**
A meme object, with top & bottom text, the original image, and
the "memed" image with text overlaid, that can be saved tusing NSCoding
*/
struct Meme {
  var topText: String
  var bottomText: String
  var image: UIImage
  var memedImage: UIImage
}

/// from https://github.com/SonoPlot/PropertyListSwiftPlayground
extension Meme: PropertyListReadable {
  func propertyListRepresentation() -> NSDictionary {
    let representation:[String:AnyObject] = [
      "topText":topText,
      "bottomText":bottomText,
      "image":UIImageJPEGRepresentation(image, 100)!,
      "memedImage":UIImageJPEGRepresentation(memedImage, 100)!
    ]
    return representation
  }

  init?(propertyListRepresentation:NSDictionary?) {
    guard let values = propertyListRepresentation else {return nil}
    if let _topText = values["topText"] as? String,
      _bottomText = values["bottomText"] as? String,
    _image = values["image"] as? NSData,
    _memedImage = values["memedImage"] as? NSData {
        topText = _topText
        bottomText = _bottomText
        image = UIImage(data: _image)!
        memedImage = UIImage(data: _memedImage)!
    } else {
      return nil
    }
  }

}
