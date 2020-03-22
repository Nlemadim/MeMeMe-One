//
//  ViewController.swift
//  MeMeMe One
//
//  Created by Tony Nlemadim on 3/21/20.
//  Copyright © 2020 Tonys Dev Ops. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let memeImagePicker = UIImagePickerController()
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var toptextField: UITextField!
    @IBOutlet weak var baseTextField: UITextField!
    @IBOutlet weak var CameraButton: UIBarButtonItem!
    
    let memeTextAttributes : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        toptextField.defaultTextAttributes = memeTextAttributes
        baseTextField.defaultTextAttributes = memeTextAttributes
        toptextField.textAlignment = NSTextAlignment.center
        baseTextField.textAlignment = NSTextAlignment.center
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override  func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    @IBAction func selectImage(_ sender: Any) {
        memeImagePicker.delegate = self
        present(memeImagePicker, animated: true, completion: nil)
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

    
    
    
    
    
    
    
    
}

