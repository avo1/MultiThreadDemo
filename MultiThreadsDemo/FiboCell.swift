//
//  FiboCell.swift
//  MultiThreadsDemo
//
//  Created by Dave Vo on 3/27/17.
//  Copyright © 2017 DaveVo. All rights reserved.
//

import UIKit

class FiboCell: UITableViewCell {
    
    var fibonacciEntry: FibonacciEntry? {
        didSet {
            self.textLabel?.text = ""

            if let entry = fibonacciEntry {
                
//                if entry.result == nil {
//                    // assume this is a very slow task
//                    for _ in 0..<100000 {
//                        _ = entry.calculate()
//                    }
//                }
//            
//                self.fibonacciEntry?.result = entry.calculate()
//                self._updateLabel()
                
                
                DispatchQueue.global(qos: .background).async {
                    if entry.result == nil {
                        // assume this is a very slow task
                        for _ in 0..<100000 {
                            _ = entry.calculate()
                        }
                    }
                    
                    DispatchQueue.main.async {
                        if self.fibonacciEntry?.number == entry.number {
                            self.fibonacciEntry?.result = entry.calculate()
                            self._updateLabel()
                        }
                    }
                }

                
            }
            
        }
    }
    
    private func _updateLabel() {
        if let result = fibonacciEntry?.result {
            self.textLabel?.text = "\(result)"
        }
    }
    
}
