//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Myron Govender on 2021/02/25.
//

import UIKit

let defaultTopText = "TOP"
let defaultBottomText = "BOTTOM"

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Variables
    let memeTextFieldDelegate: UITextFieldDelegate = MemeTextDelegate()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -5.0,
    ]
    
    //MARK: Outlets
    @IBOutlet weak var memePlaceholder: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var memeToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //MARK: Actions
    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .camera)
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType){
        //Create a UIImagePickerController, set its source type and present it here
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let meme = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (activity, completed, items, error) in
            if completed {
                self.save()
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Configure toolbar buttons
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Initialize memeTextFields
        setupMemeTextFields(textField: topTextField, defaultTextAttributes: memeTextAttributes, capitalizationType: .allCharacters, defaultText: defaultTopText, textAlignment: .center, textFieldDelegate: memeTextFieldDelegate)
        setupMemeTextFields(textField: bottomTextField, defaultTextAttributes: memeTextAttributes, capitalizationType: .allCharacters, defaultText: defaultBottomText, textAlignment: .center, textFieldDelegate: memeTextFieldDelegate)
        
        //Disable share button if there is no image in the memePlaceholderImageView
        if(memePlaceholder.image == nil){
            shareButton.isEnabled = false
        }
        
        //Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
        
        //reset meme editor when exiting
        memePlaceholder.image = nil
        topTextField.text = defaultTopText
        bottomTextField.text = defaultBottomText
        
    }
    
    //MARK: Private Methods
    
    func setupMemeTextFields(textField: UITextField, defaultTextAttributes: [NSAttributedString.Key: Any], capitalizationType: UITextAutocapitalizationType, defaultText: String, textAlignment: NSTextAlignment, textFieldDelegate: UITextFieldDelegate){
        textField.defaultTextAttributes = defaultTextAttributes //Initialize memeTextFieldAttributes
        textField.autocapitalizationType = capitalizationType //Set capitalization of TextFields to All Caps
        textField.text = defaultText //Set initial text for TextFields
        textField.textAlignment = textAlignment //Centre text fields
        textField.delegate = textFieldDelegate //Assign textfield delegate
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isFirstResponder){
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //Take a snapshot of the current view on screen
    func generateMemedImage() -> UIImage {
        
        //Hide the navbar and toolbar
        navigationController?.isNavigationBarHidden = true
        memeToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show the navbar and toolbar
        navigationController?.isNavigationBarHidden = false
        memeToolbar.isHidden = false

        return memedImage
    }
    
    // Create the meme
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memePlaceholder.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK: UIImagePickerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            memePlaceholder.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}

