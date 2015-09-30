//
//  MemesViewer.swift
//  MemeMe
//
//  Created by Michael Johnston on 29.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

protocol MemesViewer {
  var memesList: [Meme] { get }
  func populateCell(cell:MemesViewerCell, withMeme meme:Meme)
}

extension MemesViewer {
  var memesList: [Meme] {
    return MemeStore.sharedStore.savedMemes
  }
  
  func populateCell(cell:MemesViewerCell, withMeme meme:Meme) {
    let attributes = MemeTextStyle(fontSize: cell.memeTextFontSize, strokeSize: cell.memeTextStrokeSize).attributes
    cell.originalImage?.image = meme.image
    cell.topText?.attributedText = NSMutableAttributedString(string: meme.topText, attributes: attributes)
    cell.expandedTopText?.text = meme.topText
    cell.bottomText?.attributedText = NSMutableAttributedString(string: meme.bottomText, attributes: attributes)
    cell.expandedBottomText?.text = meme.bottomText
  }
}

@objc protocol MemesViewerCell {
  var originalImage: UIImageView! { get }
  var topText: UILabel! { get }
  var bottomText: UILabel! { get }
  var memeTextFontSize:CGFloat { get }
  var memeTextStrokeSize:CGFloat { get }
  optional var expandedTopText: UILabel! { get }
  optional var expandedBottomText: UILabel! { get }
}
