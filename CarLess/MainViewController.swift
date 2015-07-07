//
//  MainViewController.swift
//  CarLess
//
//  Created by Whyceewhite on 7/6/15.
//  Copyright (c) 2015 Galloway Mobile. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    @IBInspectable
    var defaultIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
