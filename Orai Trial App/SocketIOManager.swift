//
//  SocketIOManager.swift
//  Orai Trial App
//
//  Created by Chris Thompson on 11/19/17.
//  Copyright © 2017 Chris Thompson. All rights reserved.
//

import UIKit

class SocketIOManager: NSObject {

    static let sharedInstance = SocketIOManager()
    
    
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://2601:4a:600:d9a0:f1f7:985c:4629:369:3000")!)
    
    
    override init() {
        super.init()
    }

}


