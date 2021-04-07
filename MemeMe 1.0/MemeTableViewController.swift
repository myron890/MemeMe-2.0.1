//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by Myron Govender on 2021/04/06.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    // MARK: Variables
    //allow access to shared meme data model stored in AppDelegate
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Actions
    //connect button in tableView to allow navigation to edit meme view
    @IBAction func createMemeButton(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "CreateMemeViewController") as! ViewController

        // Present the view controller using navigation
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    // MARK: Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    // MARK: TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NUMBER OF CELLS IS: \(memes.count)!!!")
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memeTableViewCell")!
        cell.imageView?.image = memes[(indexPath as NSIndexPath).row].memedImage
        cell.textLabel?.text = memes[(indexPath as NSIndexPath).row].topText + "..." + memes[(indexPath as NSIndexPath).row].bottomText
        return cell
    }
        
}
