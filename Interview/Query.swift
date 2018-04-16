//
//  Query.swift
//  Interview
//
//  Created by Andres Wang on 2018/4/16.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation
import CoreData

// Note: Our own model separated from data store just in case​ ​we​ ​are​ ​asked​ ​to​ ​use​ ​a​ ​different​ ​persistent​ ​store
struct Query {
    var text: String
}

class ManagedQuery: NSManagedObject {
    @NSManaged var text: String?
    
    enum Keys: String {
        case text
    }
    
    // MARK: - Helper Methods
    class func entityName() -> String {
        return "ManagedQuery"
    }
    func toQuery() -> Query {
        return Query(text: text!)
    }
}
