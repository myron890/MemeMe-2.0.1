//
//  MemeViewViewController.swift
//  MemeMe 1.0
//
//  Created by Myron Govender on 2021/04/07.
//

import UIKit

class MemeViewViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: Variables
    
    //allow access to shared meme data model stored in AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //variable to store selected image from either table/collection view
    var memeIndex: Int?
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide tab bar
        self.tabBarController?.tabBar.isHidden = true
        
        //Set the imageView to the selected meme
        memeImageView.image = memes[memeIndex!].memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //Show tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
}
