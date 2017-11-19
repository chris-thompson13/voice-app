//
//  userObject.swift
//  Orai Trial App
//
//  Created by Chris Thompson on 11/18/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import SwiftyJSON

class UserObject {
    var pictureURL: String!
    var username: String!
    
    required init(json: JSON) {
        pictureURL = json["picture"]["medium"].stringValue
        username = json["email"].stringValue
    }
}
