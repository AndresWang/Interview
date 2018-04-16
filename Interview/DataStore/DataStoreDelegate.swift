//
//  DataStoreDelegate.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

// Note: Protocol interface for database communication just in case we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​persistent​ ​store​.
protocol DataStoreDelegate {
    func saveSuccessfulQuery(text: String)
}

// Note: CoreData as our DataStoreDelegate
extension CoreDataStore: DataStoreDelegate {
    func saveSuccessfulQuery(text: String) {
        let newQuery = NSEntityDescription.insertNewObject(forEntityName: ManagedQuery.entityName(), into: context) as! ManagedQuery
        newQuery.text = text
        saveContext()
    }
}
