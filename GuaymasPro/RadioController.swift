//
//  RadioController.swift
//  GuaymasPro
//
//  Created by Jhonatan Laguna on 19/04/16.
//  Copyright © 2016 Jhonatan Laguna. All rights reserved.
//

import UIKit

class RadioController: UIViewController{
    
    
    @IBOutlet weak var radioPlayer: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //https://mixlr.com/users/1847448/embed Radio
        
        let url = NSURL (string: "https://mixlr.com/users/1847448/embed")
        let requestObject = NSURLRequest(URL: url!)
        radioPlayer.loadRequest(requestObject)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
