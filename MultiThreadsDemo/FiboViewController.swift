//
//  FiboViewController.swift
//  MultiThreadsDemo
//
//  Created by Dave Vo on 3/25/17.
//  Copyright © 2017 DaveVo. All rights reserved.
//

import UIKit

class FiboViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var nRow: Int = 80
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }
    
//    override var preferredContentSize: CGSize {
//        get {
//            return CGSize(width: 300, height: 300)
//        }
//        set {
//            super.preferredContentSize = newValue
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fiboCell") as! FiboCell
        cell.fibonacciEntry = FibonacciEntry(number: indexPath.row)
        
        return cell
    }
    
}
