//
//  MailboxViewController.swift
//  HW-3-Mailbox
//
//  Created by Adam Noffsinger on 10/29/16.
//  Copyright © 2016 Adam Noffsinger. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    // outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var archiveIconImageView: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var laterIconImageView: UIImageView!
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var deleteIconImageView: UIImageView!
    @IBOutlet weak var rescheduleImageView: UIImageView!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var inboxView: UIView!
    
    // variables
    var messageOriginalCenter: CGPoint!
    var messageOffscreenRight: CGPoint!
    var messageOffscreenLeft: CGPoint!
    var iconOffscreenRight: CGPoint!
    var iconOffscreenLeft: CGPoint!
    var feedUp: CGPoint!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var inboxViewOriginalCenter: CGPoint!
    var inboxOffscreenRight: CGPoint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: 320, height: 1535)
        
        messageBackgroundView.backgroundColor = UIColor(red: 0.8784, green: 0.8784, blue: 0.8784, alpha: 1.0)

        // screen size
        let bounds = UIScreen.main.bounds
        screenWidth = bounds.size.width
        screenHeight = bounds.size.height
        
        // variables
        messageOffscreenRight = CGPoint(x: 500, y: messageView.center.y)
        messageOffscreenLeft = CGPoint(x: -160, y: messageView.center.y)
        iconOffscreenRight = CGPoint(x: 480, y: messageView.center.y)
        iconOffscreenLeft = CGPoint(x: -140, y: messageView.center.y)
        feedUp = CGPoint(x: 160, y: 831 - messageView.frame.height)
        inboxViewOriginalCenter = CGPoint(x: inboxView.center.x, y: inboxView.center.y)
        inboxOffscreenRight = CGPoint(x: 450, y: inboxView.center.y)
        
        laterIconImageView.alpha = 0
        archiveIconImageView.alpha = 0
        listIconImageView.alpha = 0
        deleteIconImageView.alpha = 0
        rescheduleImageView.alpha = 0
        listImageView.alpha = 0
        
        // Instantiate and initialize the screen edge pan gesture recognizer
        let screenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didScreenEdgePan(sender:)))
        
        // Configure the screen edges you want to detect.
        screenEdgePanGestureRecognizer.edges = UIRectEdge.left
        
        // Attach the screen edge pan gesture recognizer to some view.
        inboxView.isUserInteractionEnabled = true
        inboxView.addGestureRecognizer(screenEdgePanGestureRecognizer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didSwipeMessage(_ sender: UIPanGestureRecognizer) {
        
        // translation returns x and y coordinates from the gesture recognizer
        let translation = sender.translation(in: view)
        
        print("translation \(translation)")
        
        // gesture starts
        if sender.state == .began {
            messageOriginalCenter = messageView.center
        
        // when gesture is continuing
        } else if sender.state == .changed {
            
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            if translation.x < 0 && translation.x > -60.0 {
                let opacity = convertValue(inputValue: CGFloat(translation.x), r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
                laterIconImageView.alpha = opacity
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageBackgroundView.backgroundColor = UIColor(red: 0.8784, green: 0.8784, blue: 0.8784, alpha: 1.0)
                })
                
            } else if translation.x <= -60.0 && translation.x > -260.0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageBackgroundView.backgroundColor = UIColor.yellow
                })
                laterIconImageView.alpha = 1
                listIconImageView.alpha = 0
                
                
            } else if translation.x >= -screenWidth && translation.x < -260.0{
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageBackgroundView.backgroundColor = UIColor.brown
                })
                laterIconImageView.alpha = 0
                listIconImageView.alpha = 1
                
            } else if translation.x >= 0 && translation.x < 60.0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageBackgroundView.backgroundColor = UIColor(red: 0.8784, green: 0.8784, blue: 0.8784, alpha: 1.0)
                })
                let opacity = convertValue(inputValue: CGFloat(translation.x), r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
                archiveIconImageView.alpha = opacity
            
            } else if translation.x >= 60 && translation.x < 260 {
                
                deleteIconImageView.alpha = 0
                archiveIconImageView.alpha = 1
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageBackgroundView.backgroundColor = UIColor.green
                })
            
            } else if translation.x >= 260 && translation.x < screenWidth {
                
                // switch icons, switch background color
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageBackgroundView.backgroundColor = UIColor.red
                })
                archiveIconImageView.alpha = 0
                deleteIconImageView.alpha = 1
                
            } else if translation.x <= -260 && translation.x > -screenWidth {
                listIconImageView.alpha = 1
            }
            
            
            if translation.x > 60 {
                archiveIconImageView.frame.origin.x = translation.x - 20
                deleteIconImageView.frame.origin.x = translation.x - 20
            } else if translation.x < -60 {
                laterIconImageView.frame.origin.x = translation.x + screenWidth + 24 + 12.5
                listIconImageView.frame.origin.x = translation.x + screenWidth + 24 + 12.5
            }
        
        // when gesture ends
        } else if sender.state == .ended {
            // if under 60 in translation, snap back to original position
            
            if translation.x >= -screenWidth && translation.x < -260.0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.messageView.center = self.messageOffscreenLeft
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.listIconImageView.center = self.iconOffscreenLeft
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.listImageView.alpha = 1
                    }, completion: nil)
            } else if translation.x >= -260 && translation.x < -60 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.messageView.center = self.messageOffscreenLeft
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.laterIconImageView.center = self.iconOffscreenLeft
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                    self.rescheduleImageView.alpha = 1
                    }, completion: nil)
                
            } else if translation.x >= -60.0 && translation.x <= 60.0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.messageView.center = self.messageOriginalCenter
                    }, completion: nil)
            } else if translation.x > 60.0 && translation.x <= 260.0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.messageView.center = self.messageOffscreenRight
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.archiveIconImageView.center = self.iconOffscreenRight
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                    self.feedImageView.center = self.feedUp
                    }, completion: nil)
            } else if translation.x > 260.0 {
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.messageView.center = self.messageOffscreenRight
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                    self.deleteIconImageView.center = self.iconOffscreenRight
                    }, completion: nil)
                UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
                    self.feedImageView.center = self.feedUp
                    }, completion: nil)
            }
        }
    }
    
    
    @IBAction func didTapReschedule(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.rescheduleImageView.alpha = 0
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
            self.feedImageView.center = self.feedUp
            }, completion: nil)
    }

    @IBAction func didTapList(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.listImageView.alpha = 0
            }, completion: nil)
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
            self.feedImageView.center = self.feedUp
            }, completion: nil)
    }
    
    func didScreenEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        
        let swipeTranslation = sender.translation(in: view)
        
        print("translation \(swipeTranslation)")
        
        if sender.state == .began {
//            trayOriginalCenter = trayView.center
            print("began")
        } else if sender.state == .changed {
            print("changed")
            inboxView.frame.origin.x = swipeTranslation.x
//            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("ended")
            
//            if translation.x >
            var velocity = sender.velocity(in: view)
////
            if velocity.x > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    self.inboxView.center = self.inboxOffscreenRight
                    }, completion: nil)
            } else {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
                    self.inboxView.center = self.inboxViewOriginalCenter
                    }, completion: nil)
            }
        }
    }
    
}
