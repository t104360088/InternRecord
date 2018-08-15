//
//  DatabaseManager.swift
//  message
//
//  Created by RD-Air01 on 2018/8/11.
//  Copyright © 2018年 RD-Air01. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager: NSObject {
    private static var mInstance: DatabaseManager?
    private var dbRef: DatabaseReference?
    
    override private init() {
        super.init()
        self.dbRef = Database.database().reference()
    }
    
    // MARK: Public method
    static func sharedInstance() -> DatabaseManager {
        if mInstance == nil {
            mInstance = DatabaseManager()
        }
        return mInstance!
    }
    
    func uploadToken(_ token: String) {
        dbRef?.child("token").setValue(token)
    }
}
