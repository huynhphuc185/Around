//
//  RelateProductViewController.swift
//  Around
//
//  Created by phuc.huynh on 2/16/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class RelateProductViewController: StatusBarWithSearchBarViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
 @IBOutlet weak var mainCollectionView: UICollectionView!
    var listCategory : [Product] = []
    var id_product : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        DataConnect.getRelateProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: id_product!, page: 1, view: self.view, onsuccess: { (result) in
            self.listCategory = (result as? [Product])!
            self.mainCollectionView.reloadData()
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: false)
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "DetailViewProductViewController") as! DetailViewProductViewController
        vc.product_ID = listCategory[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategory.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RelateCell", for: indexPath) as! RelateCell
        if let url = URL(string: listCategory[indexPath.row].image!),let placeholder = UIImage(named: "default_product") {
            cell.imageAvatar.sd_setImageWithURLWithFade(url, placeholderImage: placeholder)
        }
        cell.lblName.text = listCategory[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInLine: CGFloat = 2
        
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let minimumInteritemSpacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: indexPath.section)
        let itemWidth = (collectionView.frame.width - inset.left - inset.right - minimumInteritemSpacing * (numberOfItemsInLine - 1)) / numberOfItemsInLine
        let itemHeight = itemWidth
        
        return CGSize(width: itemWidth, height: itemHeight)
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
}
class RelateCell: UICollectionViewCell
{
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
}
