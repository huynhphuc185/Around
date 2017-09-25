//
//  TutorialViewController.swift
//  UIPageViewController Post
//
//  Created by Jeffrey Burt on 2/3/16.
//  Copyright © 2016 Seven Even. All rights reserved.
//

import UIKit

class TutorialViewController: StatusbarViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnRegister: UIButton!
    var tutorialPageViewController: TutorialPageViewController? {
        didSet {
            tutorialPageViewController?.tutorialDelegate = self
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        pageControl.addTarget(self, action: #selector(TutorialViewController.didChangePageControlValue), for: .valueChanged)
        pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        NotificationCenter.default.addObserver(self, selector: #selector(TutorialViewController.jumpToPage(_:)), name:NSNotification.Name(rawValue: "jumpToPage"), object: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if Config.sharedInstance.maintenance?.status == 1
        {
            if MCLocalization.sharedInstance().language == "en"
            {
                customAlertView(self, title: (Config.sharedInstance.maintenance?.message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                    Config.sharedInstance.maintenance = nil
                    Config.sharedInstance.update = nil
                    exit(0)
                }
            }
            else
            {
                customAlertView(self, title: (Config.sharedInstance.maintenance?.vn_message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "CONFIRM")) { result in
                    Config.sharedInstance.maintenance = nil
                    Config.sharedInstance.update = nil
                    exit(0)
                }
            }
        }
        else
        {
            
            if Config.sharedInstance.update?.status == 1
            {
                if MCLocalization.sharedInstance().language == "en"
                {
                    customAlertViewWithCancelButton(self, title: (Config.sharedInstance.update?.message)!, btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "UPDATE"), titleGreyButton: MCLocalization.string(forKey: "SKIP"), isClose: false,  blockCallback: {result in
                        if let url = URL(string: (Config.sharedInstance.update?.url)!),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.openURL(url)
                        }
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                    }, blockCallbackCancel: {result in
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                    })
                }
                else
                {
                    customAlertViewWithCancelButton(self, title: (Config.sharedInstance.update?.vn_message)!, btnTitleNameNormal: name_confirm_Button_Normal,  btnCancelNameNormal: name_cancel_Button_Normal,titleOrangeButton: MCLocalization.string(forKey: "UPDATE"), titleGreyButton: MCLocalization.string(forKey: "SKIP"), isClose: false,  blockCallback: {result in
                        if let url = URL(string: (Config.sharedInstance.update?.url)!),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.openURL(url)
                        }
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                    }, blockCallbackCancel: {result in
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                    })
                    
                }
            }
            else if Config.sharedInstance.update?.status == 2
            {
                if MCLocalization.sharedInstance().language == "en"
                {
                    customAlertView(self, title: (Config.sharedInstance.update?.message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "UPDATE")) { result in
                        if let url = URL(string: (Config.sharedInstance.update?.url)!),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.openURL(url)
                        }
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                        exit(0)
                        
                    }
                }
                else
                {
                    customAlertView(self, title: (Config.sharedInstance.update?.vn_message)!, btnTitleNameNormal: name_confirm_Button_Normal,titleButton: MCLocalization.string(forKey: "UPDATE")) { result in
                        if let url = URL(string: (Config.sharedInstance.update?.url)!),
                            UIApplication.shared.canOpenURL(url){
                            UIApplication.shared.openURL(url)
                        }
                        Config.sharedInstance.maintenance = nil
                        Config.sharedInstance.update = nil
                        exit(0)
                        
                    }
                    
                }
            }
            
        }
    }
     func jumpToPage(_ notify : Notification) {
        tutorialPageViewController?.scrollToNextViewController()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tutorialPageViewController = segue.destination as? TutorialPageViewController {
            self.tutorialPageViewController = tutorialPageViewController
        }
    }
    @IBAction func didTapNextButton(_ sender: UIButton) {
        tutorialPageViewController?.scrollToNextViewController()
    }
    @IBAction func btnLoginClick(_ sender: UIButton) {
        tracking(actionKey: "C1.1Y")
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "LoginByPhoneViewController") as! LoginByPhoneViewController
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnRegisterClick(_ sender: UIButton) {
        tracking(actionKey: "C1.2Y")
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "RegisterPhoneNumberViewController") as! RegisterPhoneNumberViewController
        vc.flagLogin = false
        self.present(vc, animated: true, completion: nil)
    }
    /**
     Fired when the user taps on the pageControl to change its current page.
     */
    func didChangePageControlValue() {
       tutorialPageViewController?.scrollToViewController(index: pageControl.currentPage)
    }
}

extension TutorialViewController: TutorialPageViewControllerDelegate {
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
        didUpdatePageCount count: Int) {
            pageControl.numberOfPages = count
    }
    
    func tutorialPageViewController(_ tutorialPageViewController: TutorialPageViewController,
        didUpdatePageIndex index: Int) {
            pageControl.currentPage = index
    }
    
}
