//
//  MemeViewer.swift
//  MemeMe
//
//  Created by Michael Johnston on 05.10.2015.
//  Copyright © 2015 Michael Johnston. All rights reserved.
//

import UIKit
/**
Encapsulates code shared between the meme editor and the meme detail view
*/
protocol MemeViewer {
  var meme: Meme? {get set}
}

