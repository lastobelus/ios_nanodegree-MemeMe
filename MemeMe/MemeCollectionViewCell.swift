//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Michael Johnston on 28.09.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit

class MemeCollectionViewCell: UICollectionViewCell, MemesViewerCell {

  @IBOutlet weak var originalImage: UIImageView!
  @IBOutlet weak var topText: UILabel!
  @IBOutlet weak var bottomText: UILabel!

  let memeTextFontSize:CGFloat = 15
  let memeTextStrokeSize:CGFloat = 4.0

  override func awakeFromNib() {
    super.awakeFromNib()
  }

}
