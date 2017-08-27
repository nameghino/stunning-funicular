//
//  ViewController.swift
//  RXBTLEMessaging
//
//  Created by Nico Ameghino on 8/27/17.
//  Copyright © 2017 Nico Ameghino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let inboundMessagingManager = InboundMessagingManager(advertisingName: "test")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        inboundMessagingManager.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

