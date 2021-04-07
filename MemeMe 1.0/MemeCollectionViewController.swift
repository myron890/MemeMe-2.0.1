//
//  MemeCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by Myron Govender on 2021/04/06.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    // MARK: Variables
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Actions
    @IBAction func createMemeButton(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateMemeViewController") as! ViewController

        // Present the view controller using navigation
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    // MARK: CollectionView Data Source Methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        
        cell.imageView.image = memes[(indexPath as NSIndexPath).row].memedImage
        
        return cell
    }
    
}
