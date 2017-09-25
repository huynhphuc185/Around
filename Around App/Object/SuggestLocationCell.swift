
class SuggestLocation : UITableViewCell
{
    static let identifier = "suggestionCell"
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var viewIcon: UIView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var txtPickup: CustomTextFieldWithImage!
    @IBOutlet weak var btnEdit: UIButton!
     @IBOutlet weak var viewDrop: UIView!
     @IBOutlet weak var line: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var imageEmpty: UIImageView!
    func prepareCell(_ point :PointLocation, index: Int, list: [PointLocation])
    {
        viewIcon.backgroundColor = UIColor.clear
        viewDrop.backgroundColor = UIColor.clear
        imageViewIcon.isHidden = false
        lblNumber.text = String(format: "%d", index+1)
        
        if point.role == 0
        {
            txtPickup.textColor = UIColor(hex: colorCam)
            if  point.address == ""
            {
                txtPickup.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "PICKUPWHERE"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                txtPickup.text = ""
            }
            else
            {
                txtPickup.text = point.address
            }
            topLine.isHidden = true
            bottomLine.isHidden = false
            if list[index+1].role == 3
            {
               bottomLine.backgroundColor = UIColor(hex: colorXam)
            }
            else
            {
                 bottomLine.backgroundColor = UIColor(hex: colorCam)
            }
        }
        else if point.role == 3
        {
            imageViewIcon.isHidden = true
            viewDrop.backgroundColor = UIColor.gray
            lblNumber.text = ""
            txtPickup.textColor = UIColor(hex: colorXam)
            if  point.address == ""
            {
                txtPickup.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "NHAPDIADIEMNHAN"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                txtPickup.text = ""
            }
            else
            {
                txtPickup.text = point.address
            }
            topLine.isHidden = false
            topLine.backgroundColor = UIColor(hex: colorXam)
            bottomLine.isHidden = true
           
            
        }
        else{
            txtPickup.textColor = UIColor(hex: colorCam)
            if  point.address == ""
            {
                txtPickup.attributedPlaceholder = NSAttributedString(string: MCLocalization.string(forKey: "PICKUPWHERE"),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor(hex: colorXam)])
                txtPickup.text = ""
            }
            else
            {
                txtPickup.text = point.address
            }
            bottomLine.isHidden = false
            topLine.isHidden = false
            if list[index+1].role == 3
            {
                topLine.backgroundColor = UIColor(hex: colorCam)
                bottomLine.backgroundColor = UIColor(hex: colorXam)
            }
            else
            {
                topLine.backgroundColor = UIColor(hex: colorCam)
                bottomLine.backgroundColor = UIColor(hex: colorCam)
            }
        }
        

        
    }
    
   }
