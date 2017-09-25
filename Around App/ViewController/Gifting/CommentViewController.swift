//
//  CommentViewController.swift
//  Around
//
//  Created by phuc.huynh on 2/16/17.
//  Copyright © 2017 phuc.huynh. All rights reserved.
//

import UIKit

class CommentViewController: StatusBarWithSearchBarViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tblViewComment: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    @IBOutlet weak var btnWriteComment: UIButton!
    var id_product: Int?
    var arrayComments: TotalComments?
    var enableRate : Bool?
    var pageIndex = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tblViewComment.rowHeight = UITableViewAutomaticDimension
        tblViewComment.estimatedRowHeight = 300
        tblViewComment.addPullToRefreshHandler {
            DataConnect.getComment(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: self.id_product!, page: 1, view: self.view, onsuccess: { (result) in
                self.arrayComments = result as? TotalComments
                self.tblViewComment.reloadData()
                self.tblViewComment.pullToRefreshView?.stopAnimating()
            }) { (error) in
                showErrorMessage(error: error as! Int, vc: self)
            }

        }
        
        tblViewComment.addInfiniteScrollingWithHandler {
            DispatchQueue.global(qos: .userInitiated).async {
                sleep(3)
                DispatchQueue.main.async { [unowned self] in
                    self.pageIndex = self.pageIndex + 1
                    
                    DataConnect.getComment(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: self.id_product!, page:self.pageIndex , view: self.view, onsuccess: { (result) in
                        
                        if let data = result as? TotalComments
                        {
                            for item in (data.comments?.enumerated())!
                            {
                               self.arrayComments?.comments?.append(item.element)
                            }
                        }
                        self.tblViewComment.reloadData()
                         self.tblViewComment.infiniteScrollingView?.stopAnimating()
                    }) { (error) in
                        showErrorMessage(error: error as! Int, vc: self)
                    }
                }
            }
        }

        //btnWriteComment.setBackgroundImage(UIImage.dottedLine(radius: 2, space: 0.5, numberOfPattern: 1), for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        makeTopNavigationSearchbar(isMenuScreen: false,isCartScreen: false,needShake: false)

        DataConnect.getComment(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: id_product!, page: 1, view: self.view, onsuccess: { (result) in
            self.arrayComments = result as? TotalComments
            if self.arrayComments?.comments?.count == 0
            {
                self.viewEmpty.isHidden = false
                self.tblViewComment.isHidden = true
            }
            else{
                self.viewEmpty.isHidden = true
                self.tblViewComment.isHidden = false
                self.tblViewComment.reloadData()
            }
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
        
        DataConnect.getDetailProduct(token_API, country_code: kCountryCode, phone: userPhone_API, id_product: id_product!, view: nil, onsuccess: { (result) in
           // self.detailProductObj = result as? DetailProduct
            if let detailObj = result as? DetailProduct
            {
                self.enableRate = detailObj.is_rate
            }
            
        }) { (error) in
            showErrorMessage(error: error as! Int, vc: self)
        }
    }
   
    
    @IBAction func btnWriteComment (_ sender: UIButton)
    {
        let vc = giftingStoryBoard.instantiateViewController(withIdentifier: "WriteCommentViewController") as! WriteCommentViewController
        vc.enableRate = enableRate
        vc.id_product = id_product
        let nvc = UINavigationController(rootViewController: vc)
        self.present(nvc, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return resultsArray.count
        if (arrayComments != nil)
        {
        return (arrayComments?.comments?.count)!
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblViewComment.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        if let url_ = URL(string: (arrayComments?.comments?[indexPath.row].user_avatar)!),let placeholder = UIImage(named: "avatar_Background") {
            loadDataByGCD(url: url_, onsuccess: { (result) in
                if result != nil
                {
                    cell.imageAvatar.image = UIImage(data: result as! Data)?.circleMasked
                    cell.imageAvatar.setShadowBorder()
                }
                else
                {
                    appDelegate.imageUser = placeholder
                }
                
            })

            
        }
        if arrayComments?.comments?[indexPath.row].user_name == ""
        {
            cell.lblName.text = "User"
        }
        else{
            cell.lblName.text = arrayComments?.comments?[indexPath.row].user_name
        }

        let time = changeFormatTime(timeString: (arrayComments?.comments?[indexPath.row].time)!, oldFormat: "yyyy-MM-dd HH:mm:ss", newFormat: "h:mm a | EEE, dd MMMM, yyyy")
        
        cell.lblTime.text = time
        cell.lblComment.text = arrayComments?.comments?[indexPath.row].comment
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        
    }
    
    
}
class CommentCell: UITableViewCell
{
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var viewDot: UIView!
}
