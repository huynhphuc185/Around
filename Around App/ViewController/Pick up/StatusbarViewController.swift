//
//  StatusbarViewController.swift
//  Around App
//
//  Created by phuc.huynh on 8/5/16.
//  Copyright © 2016 phuc.huynh. All rights reserved.
//

import UIKit

class StatusbarViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.navigationController?.isNavigationBarHidden =  true
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation
    {
        return UIStatusBarAnimation.slide
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let vc = self as? RegisterPhoneNumberViewController{
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }
            
        }
        else if let vc = self as? VerifyOTPViewController
        {
            
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }
        }
        else if let vc = self as? SignUpToShipViewController
        {
            
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }
        }
            
        else if let vc = self as? PaymentInfoViewController
        {
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = -70
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }

        }
        else if let vc = self as? ViAroundViewController
        {
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = -70
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }
            
        }
        else if let vc = self as? InformationPickUpViewController
        {
            
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
              
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                
              
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.constrainBottom?.constant = 0.0
                } else {
                    vc.constrainBottom?.constant = (endFrame?.size.height)! - 20
                    
                }
                self.view.layoutIfNeeded()
            }
        }
        else if let vc = self as? DropInformationViewController
        {
            
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue

                
                
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.constrainBottom?.constant = 0.0
                } else {
                    vc.constrainBottom?.constant = (endFrame?.size.height)! - (ScreenSize.SCREEN_HEIGHT - 420)/2
                    
                }
                self.view.layoutIfNeeded()
            }
        }

        else if let vc = self as? ToBeSupplierViewController
        {
            
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
     
                
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.constrainBottom?.constant = 0.0
                } else {
                    vc.constrainBottom?.constant = (endFrame?.size.height)!
                    
                }
                self.view.layoutIfNeeded()
            }
        }
  
        else if let vc = self as? AlertWithTextFieldViewController
        {
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
                let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
                let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                }
                UIView.animate(withDuration: duration,
                               delay: TimeInterval(0),
                               options: animationCurve,
                               animations: { self.view.layoutIfNeeded() },
                               completion: nil)
            }
            
        }
            
        else if  let vc = self as?  UserProfileViewController
        {
            if let userInfo = notification.userInfo {
                let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
                if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                    vc.keyboardHeightLayoutConstraint?.constant = 0.0
                } else {
                    vc.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                }
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                })
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
