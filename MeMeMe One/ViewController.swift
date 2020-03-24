//
//  ViewController.swift
//  MeMeMe One
//
//  Created by Tony Nlemadim on 3/21/20.
//  Copyright © 2020 Tonys Dev Ops. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    let memeImagePicker = UIImagePickerController()
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var toptextField: UITextField!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var CameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    
    //    TextField Style Attributes
    let memeTextAttributes : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    struct Meme {
        let topText: String!
        let baseText: String!
        let originalImage: UIImage!
        let memedImage: UIImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Top TextField Attributes
        toptextField.delegate = self
        toptextField.defaultTextAttributes = memeTextAttributes
        toptextField.textAlignment = NSTextAlignment.center
        //   Base TextField Attributes
        baseTextField.delegate = self
        baseTextField.defaultTextAttributes = memeTextAttributes
        baseTextField.textAlignment = NSTextAlignment.center
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Notifications Subscription
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //    Move View for keyboard
    @objc func keyboardWillShow(_ notification:Notification) {
        if baseTextField.isFirstResponder {
            view.frame.origin.y = -1 * getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Notifications Unsubscription
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    // Image Picker Functions
    @IBAction func selectImage(_ sender: Any) {
        memeImagePicker.delegate = self
        present(memeImagePicker, animated: true, completion: nil)
    }
    func pickAnImageFromAlbum(_ sender: Any) {
        let memeImagePicker = UIImagePickerController()
        memeImagePicker.delegate = self
        memeImagePicker.sourceType = .photoLibrary
        present(memeImagePicker, animated: true, completion: nil)
    }
    @IBAction func CameraImage(_ sender: Any) {
        let memeImagePicker = UIImagePickerController()
        memeImagePicker.delegate = self
        memeImagePicker.sourceType = .camera
        present(memeImagePicker, animated: true, completion: nil)
    }
    
    // TextField Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        textField.resignFirstResponder()
        cancelButton.isEnabled = true
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.uppercased()) ?? string
        textField.text = String(newText)
        return false
    }
    
    
    //    UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            memeImage.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func generatedMemedImage()-> UIImage {
        
        //        Hide Tool/Navigation Bar
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        
        //        Render view To Image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //        show Tool/Navigation Bar
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.isToolbarHidden = false
        
        return memedImage
    }
    
    
    @IBAction func shareMemeImage(_ sender: Any) {
        
        let memedImage = generatedMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activity, completed, items,error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func save() {
        let memedImage = generatedMemedImage()
        _ = Meme(topText: toptextField.text!, baseText: baseTextField.text!, originalImage: memeImage.image!, memedImage: memedImage )

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}

