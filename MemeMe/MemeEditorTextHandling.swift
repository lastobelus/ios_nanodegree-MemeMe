//
//  MemeEditorTextHandling.swift
//  MemeMe
//
//  Created by Michael Johnston on 22.08.2015.
//  Copyright (c) 2015 Michael Johnston. All rights reserved.
//

import UIKit

extension MemeEditorViewController {
  func keyboardWillShow(notification: NSNotification) {
    currentKeyboardHeight = getKeyboardHeight(notification)
    animateLayout()
  }
  
  func keyboardWillHide(notification: NSNotification) {
    currentKeyboardHeight = 0
    animateLayout()
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    activeTextField = textField
    animateLayout()
  }

   func subscribeToKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWillShow:",
      name: UIKeyboardWillShowNotification,
      object: nil
    )
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "keyboardWillHide:",
      name: UIKeyboardWillHideNotification,
      object: nil
    )
  }
  
   func unsubscribeFromKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  

}