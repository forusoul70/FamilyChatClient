//
//  Message+CoreDataProperties.swift
//  FamilyChat
//
//  Created by 이상화 on 2016. 9. 13..
//  Copyright © 2016년 lee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var address: String?
    @NSManaged var body: String?
    @NSManaged var content: String?
    @NSManaged var inSend: NSNumber?
    @NSManaged var status: NSNumber?
    @NSManaged var timestamp: NSDate?

}
