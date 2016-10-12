
//  ConversationTableController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 10..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit
import CoreData

class ConversationTableController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView:UITableView!
    let cellId : String! = "conversationcell";
    var conversationList : Array<Message>?
    
    fileprivate func loadConversationList() {
        self.conversationList = CoreDataHelper.getConversationList()
//        self.conversationList = CoreDataHelper.getAllConversation()
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadConversationList()
        BroadcastManager.shared.addListener(eventName: "insertMessage") {
            DispatchQueue.main.async {
                self.loadConversationList()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.conversationList?.count ?? 0
        return count > 0 ? 1 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.conversationList?.count ?? 0
        return count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.conversationList?[indexPath.row]
        
        let cell:ConversationCell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as! ConversationCell
        
        cell.addressLabel.text = message?.address
        cell.bodyText?.text = message?.body
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let messageViewController:MessagesTableViewController = segue.destination as! MessagesTableViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if let message = self.conversationList?[indexPath.row] {
                messageViewController.conversation = CoversationModel(address:message.value(forKey: "address") as! String,
                    timestamp: Date(),
                    body: "")
            }
            
        }
    }
}
