//
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
    var conversationList : NSFetchedResultsController?
    
    private func loadConversationList() {
        self.conversationList = CoreDataHelper.getConversationList()

        do {
            try conversationList?.performFetch()
        } catch{
            abort()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadConversationList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = self.conversationList?.sections?.count
        return count!
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.conversationList?.sections![section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = self.conversationList?.objectAtIndexPath(indexPath)
        
        let cell:ConversationCell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath) as! ConversationCell
        
        cell.addressLabel.text = message?.valueForKey("address")?.description
        cell.detailTextLabel?.text = message?.valueForKey("body")?.description
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let messageViewController:MessagesTableViewController = segue.destinationViewController as! MessagesTableViewController
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if let message = self.conversationList?.objectAtIndexPath(indexPath) {
                messageViewController.conversation = CoversationModel(address:message.valueForKey("address") as! String,
                    timestamp: NSDate(),
                    body: "")
            }
            
        }
    }
}
