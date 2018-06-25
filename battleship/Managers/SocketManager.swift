//
//  SocketManager.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 21/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit
import SocketIO

protocol SocketIODelegate {
    
    func gameStart(data: [Any])
    func gameEnd(data: [Any])
    func fire(data: [Any])
    func placementEnd(data: [Any])
}

class SocketIOManager: NSObject {
    let sharedManager = SocketIOManager()
    
    var delegate : SocketIODelegate?
    
    
    var manager = SocketManager(socketURL: URL(string: "http://myurl.com/")!, config: [.log(true), .compress])
    var socket : SocketIOClient?
    
    
    func initSocket() {
        socket = manager.defaultSocket
        
        
        socket?.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket?.on("startGame", callback: { data, ack in
            self.delegate?.gameStart(data: data)
        })
        socket?.on("startEnd", callback: { data, ack in
            self.delegate?.gameEnd(data: data)
        })
        socket?.on("fire", callback: { data, ack in
            self.delegate?.fire(data: data)
        })
        socket?.on("placementEnd", callback: { data, ack in
            self.delegate?.placementEnd(data: data)
        })
        
        socket!.connect()
    }
    
    func emit(event name: String, param: Dictionary<String, Any>) {
        socket?.emit(name, param)
    }
    
    
    
    
}
