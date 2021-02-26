//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Myron Govender on 2021/02/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var memePlaceholder: UIImageView!
    
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        present(pickerController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

