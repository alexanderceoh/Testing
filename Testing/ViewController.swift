//
//  ViewController.swift
//  Testing
//
//  Created by alex oh on 2/16/16.
//  Copyright © 2016 Alex Oh. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var finishedEvents: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.getEventsNearby()
//        Networking.getEventsNearby { (returnedInfo) -> () in
//            self.finishedEvents = returnedInfo
//            print(self.finishedEvents)
//        }
//        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    struct User {
        var lastName = ""
        var firstName = ""
        
        var fullName: String {
            get {
                return firstName + " " + lastName
            }
        }
    }
}






