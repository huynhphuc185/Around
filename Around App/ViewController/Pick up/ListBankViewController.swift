//
//  ListBankViewController.swift
//  Around
//
//  Created by phuc.huynh on 3/3/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class ListBankViewController: StatusbarViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sidebarButton: UIBarButtonItem!
    var delegate : protocolPaymentWebView?
    var chooseMethod : PaymentNganLuong = PaymentNganLuong()
    var listBank : [[Bank]]?
    var order_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidebarButton.action = #selector(self.back)
        listBank = stride(from: 0, to: chooseMethod.payment_data.count, by: 2).map {
            Array(chooseMethod.payment_data[$0..<min($0 + 2, chooseMethod.payment_data.count)])
        }
        
    }
    func back ()
    {
        self.navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "PaymentWebViewViewController") as! PaymentWebViewViewController
       // vc.bank = chooseMethod.payment_data[indexPath.row]
        let item  = (self.listBank?[indexPath.section])! as [Bank]
      //  vc.bank = item[indexPath.row]
        //vc.payment_code = chooseMethod.payment_code!
        vc.delegate = delegate
        vc.order_id = order_id
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return listBank!.count
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return listBank![section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BankCell", for: indexPath) as! BankCell
        let item  = (self.listBank?[indexPath.section])! as [Bank]
        if let url = URL(string: item[indexPath.row].bank_image!),let placeholder = UIImage(named: "default_product") {
            cell.imageView.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
        }
        
        if indexPath.section % 2 == 0
        {
            if indexPath.row % 2 == 0
            {
                cell.backgroundColor =  UIColor(hex: "#d7d7d7")
            }
            else
            {
                cell.backgroundColor = UIColor.clear
            }
        }
        else
        {
            if indexPath.row % 2 == 0
            {
                cell.backgroundColor = UIColor.clear
            }
            else
            {
                cell.backgroundColor =  UIColor(hex: "#d7d7d7")
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInLine: CGFloat = 2
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        
        let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
        let itemHeight = collectionView.frame.height/3
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
}
