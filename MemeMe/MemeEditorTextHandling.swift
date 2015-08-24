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
    animateLayout(nil)
  }
  
  func keyboardWillHide(notification: NSNotification) {
    currentKeyboardHeight = 0
    animateLayout(nil)
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    activeTextField = textField
    topToolbarShouldHide = true
    bottomToolbarShouldHide = true
    
    if textIsDefault(textField) {
      textField.text = ""
    }
    animateLayout(nil)
  }

  func textFieldDidEndEditing(textField: UITextField) {
    if count(textField.text) == 0 {
      textField.text = textFieldDefaultText[textField]
    }
    manageButtonState()
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
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    if textField == topTextField {
      bottomTextField.becomeFirstResponder()
    } else {
      topToolbarShouldHide = false
      bottomToolbarShouldHide = false
      animateLayout(nil)
    }
    
    return true;
  }
  
  private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    return keyboardSize.CGRectValue().height
  }
  

}