//
//  MemesViewerCell.swift
//  MemeMe
//
//  Created by Michael Johnston on 05.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit
/**
Encapsulates code & functionality shared between the table view cells and grid view cells that display memes.
*/
@objc protocol MemesViewerCell {
  var originalImage: UIImageView! { get }
  var topText: UILabel! { get }
  var bottomText: UILabel! { get }
  var memeTextFontSize:CGFloat { get }
  var memeTextStrokeSize:CGFloat { get }
  optional var expandedTopText: UILabel! { get }
  optional var expandedBottomText: UILabel! { get }
}

