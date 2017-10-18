//
//  TestViewController.swift
//  Pilot_Invitee
//
//  Created by Gokula K Narasimhan on 10/17/17.
//  Copyright © 2017 Gokula K Narasimhan. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func close(_ sender: Any) {
        
        self.dismiss(animated:true, completion: nil)
    }
    
}
