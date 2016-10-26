//
//  FriendListController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 10. 26..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit

class FriendListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let cellId : String! = "FriendListCell";
    @IBOutlet weak var tableView: UITableView!
    private var friendList:Array<Friends> = Array<Friends>()
    
    func loadFrinedList() -> Void {
        DispatchQueue.global().async {
            let loadedList = CoreDataHelper.getAllFriendList()
            DispatchQueue.main.async {
                self.friendList.removeAll()
                if (loadedList.count > 0) {
                    self.friendList.append(contentsOf: loadedList)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        loadFrinedList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.friendList.count
        return count > 0 ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.friendList.count
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = self.friendList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendListController.cellId, for: indexPath) as! FriendListCell
        cell.profileName.text = friend.account
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        
    }
    
    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
      
        let messageViewController:MessagesTableViewController = segue.destination as! MessagesTableViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let friend = self.friendList[indexPath.row]
            if (ValidationUtils.isValid(friend.account)) {
                messageViewController.conversation = CoversationModel(address: friend.account!, timestamp: Date(), body: "")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
