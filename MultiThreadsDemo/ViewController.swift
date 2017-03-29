//
//  ViewController.swift
//  MultiThreadsDemo
//
//  Created by Dave Vo on 3/25/17.
//  Copyright © 2017 DaveVo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        loadWallpaper()
//        asyncQueue()
//        syncQueue()
//        taskWithPriority()
//        queueWithDelay()
//        concurrentTasks()
        
//        tasksShareResource()
        deadlock()
    }

    func syncQueue() {
        let queue = DispatchQueue(label: "syncQueue")
 
        queue.sync {
            for i in 1...10 {
                print("❤️ ", i)
            }
        }
        
        // this will wait for the block above
        for i in 1...10 {
            print("💚 ", i)
        }
    }

    func asyncQueue() {
        let queue = DispatchQueue(label: "asyncQueue")
        queue.async {
            for i in 1...100 {
                print("💙 ", i)
            }
        }
        
        // no more waiting, can run concurrently with the block above
        for i in 1...100 {
            print("💛 ", i)
        }
    }
    
    func taskWithPriority() {
        let queue1 = DispatchQueue(label: "queue1", qos: .userInitiated)
        let queue2 = DispatchQueue(label: "queue2", qos: .background)
        
        queue1.async {
            for i in 1...100 {
                print("❤️ ", i)
            }
        }
        queue2.async {
            for i in 1...100 {
                print("💚 ", i)
            }
        }

        // in main thread
        for i in 1...100 {
            print("💛 ", i)
        }
    }
    
    func concurrentTasks() {
    
        let queue = DispatchQueue(label: "concurrent", qos: .userInitiated, attributes: .concurrent)
        queue.async {
            for i in 1...10 {
                print("💙 ", i)
            }
        }
        
        queue.async {
            for i in 1...10 {
                print("❤️ ", i)
            }
        }
        
    }
    
    func queueWithDelay() {
        
        let delayQueue = DispatchQueue(label: "delayQueue", qos: .userInitiated)
        
        print(Date())
        
        let delay: DispatchTimeInterval = .seconds(2)
        
        delayQueue.asyncAfter(deadline: DispatchTime.now() + delay, execute: { 
            print(Date())
        })
        
        for i in 1...100 {
            print("💛 ", i)
        }
    }
    
    func tasksShareResource() {
        let semaphore = DispatchSemaphore(value: 1)
        
        let queue1 = DispatchQueue(label: "queue1", qos: .userInitiated)
        let queue2 = DispatchQueue(label: "queue2", qos: .background)
        
        queue1.async {
            print("❤️ waiting")
            semaphore.wait()
            
            for i in 1...100 {
                print("❤️ ", i)
            }
            semaphore.signal()
            print("❤️ releasing")
        }
        
        queue2.async {
            print("💚 waiting")
            semaphore.wait()
            
            for i in 1...100 {
                print("💚 ", i)
            }
            semaphore.signal()
            print("💚 releasing")
        }
        
    }
    
    func deadlock() {
        let higherPriority = DispatchQueue.global(qos: .userInitiated)
        let lowerPriority = DispatchQueue.global(qos: .utility)
        
        let semaphoreA = DispatchSemaphore(value: 1)
        let semaphoreB = DispatchSemaphore(value: 1)
        
        asyncPrint(queue: higherPriority, symbol: "❤️", firstResource: "A", firstSemaphore: semaphoreA, secondResource: "B", secondSemaphore: semaphoreB)
        
        asyncPrint(queue: lowerPriority, symbol: "💙", firstResource: "B", firstSemaphore: semaphoreB, secondResource: "A", secondSemaphore: semaphoreA)

    }
    
    func asyncPrint(queue: DispatchQueue, symbol: String, firstResource: String, firstSemaphore: DispatchSemaphore, secondResource: String, secondSemaphore: DispatchSemaphore) {
        
        func requestResource(_ resource: String, with semaphore: DispatchSemaphore) {
            print("\(symbol) waiting resource \(resource)")
            semaphore.wait()  // requesting the resource
        }
        
        queue.async {
            requestResource(firstResource, with: firstSemaphore)
            for i in 0...10 {
                if i == 5 {
                    requestResource(secondResource, with: secondSemaphore)
                }
                print(symbol, i)
            }
            
            print("\(symbol) releasing resources")
            firstSemaphore.signal() // releasing 1st resource
            secondSemaphore.signal() // releasing 2nd resource
        }
    }
    
    
    private func loadWallpaper() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard
                let wallpaperURL = URL(string: "http://wallpapers.wallhaven.cc/wallpapers/full/wallhaven-157301.jpg"),
                let imageData = NSData(contentsOf: wallpaperURL )
            else {
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: imageData as Data)
            }
        }
    }
    
    
    @IBAction func retryDeadlock(_ sender: UIButton) {
        deadlock()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let secondVC = segue.destination as! PopViewController
//        let popVC = secondVC.popoverPresentationController
//        popVC?.delegate = self
//    }
//    
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return UIModalPresentationStyle.none
//    }
}

