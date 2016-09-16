//
//  MessagesTableViewController.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 16..
//  Copyright © 2016년 lee. All rights reserved.
//

import UIKit
import CoreData

class MessagesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
    private let cellId = "messagecell"
    var conversation:CoversationModel?
    var messageList:NSFetchedResultsController?
    
    private func loadMessageList() {
        if (self.conversation == nil) {
            return
        }

        self.messageList = CoreDataHelper.getMessageByAddress(self.conversation!.address)
        do {
            try self.messageList?.performFetch()
        } catch {
            abort()
        }
        
        self.messageList?.delegate = self
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        loadMessageList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data sourc

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.messageList?.sections?.count ?? 0;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.messageList?.sections![section]
        return sectionInfo?.numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = self.messageList?.objectAtIndexPath(indexPath)
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath)
        
        cell.textLabel?.text = message?.valueForKey("address")?.description
        cell.detailTextLabel?.text = message?.valueForKey("body")?.description
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
