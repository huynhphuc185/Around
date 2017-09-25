import UIKit

class PopUpEventTextViewController: StatusbarViewController {
    var listBanner: BannerObject?
    var isSelectButtonConfirm = false
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var constrainHeightButton: NSLayoutConstraint!
    @IBOutlet weak var constrainBottom: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        if MCLocalization.sharedInstance().language == "en"
        {
            txtTitle.text = listBanner?.title
            txtDescription.text = listBanner?.contents?[0].description
        }
        else
        {
            txtTitle.text = listBanner?.vn_title
            txtDescription.text = listBanner?.contents?[0].vn_description
        }
        
        if isSelectButtonConfirm
        {
            constrainHeightButton.constant = 39
            constrainBottom.constant = 15
        }
        else
        {
            constrainHeightButton.constant = 0
            constrainBottom.constant = 0
        }
        
    }

    @IBAction func btnClose (_ sender: UIButton){
        self.dismiss(animated: false) {
        }
    }
    @IBAction func btnConfirm (_ sender: UIButton){

        weak var pvc = self.presentingViewController
        
        self.dismiss(animated: false, completion: {
            
            let vc = pickUpStoryBoard.instantiateViewController(withIdentifier: "WebDetailViewController") as! WebDetailViewController
            vc.id_notification = self.listBanner?.contents?[0].id_notification
            vc.isCloseLefftButton = true
            pvc?.present(vc, animated: true, completion: nil)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
