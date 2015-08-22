//
//  InnerViewController.swift
//  MemeMe
//
//  Created by Michael Johnston on 21.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

class InnerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    println("\n----> INNER viewWillTransitionToSize")
    print("size:             "); debugPrintln(size)
    super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    println("        after INNER super viewWillTransitionToSize")
  }
  
}