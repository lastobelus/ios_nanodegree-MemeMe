//
//  PropertyListReadable.swift
//  MemeMe
//
//  Created by Michael Johnston on 05.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import Foundation

// From http://redqueencoder.com/property-lists-and-user-defaults-in-swift/

protocol PropertyListReadable {
  func propertyListRepresentation() -> NSDictionary
  init?(propertyListRepresentation: NSDictionary?)
}

func extractValuesFromPropertyListArray<T:PropertyListReadable>(propertyListArray:[AnyObject]?) -> [T] {
  guard let encodedArray = propertyListArray else {return []}
  return encodedArray.map{$0 as? NSDictionary}.flatMap{T(propertyListRepresentation:$0)}
}

func saveValuesToDefaults<T:PropertyListReadable>(newValues:[T], key:String) {
  let encodedValues = newValues.map{$0.propertyListRepresentation()}
  NSUserDefaults.standardUserDefaults().setObject(encodedValues, forKey:key)
}
