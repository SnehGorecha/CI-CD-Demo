//
//  NotificationTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 03/11/23.
//

import UIKit
import SDWebImage

class NotificationTblViewCell: UITableViewCell {
    
    // MARK: OBJECTS & OUTLETS
    
    var didMorePressedBlock : ((_ row: Int, _ section: Int) -> Void)!
   
    @IBOutlet weak var view_btn_more: UIView!
    @IBOutlet weak var img_view_height: NSLayoutConstraint!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var img_view_notification: UIImageView!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var lbl_date_time: AFLabelLight!
    @IBOutlet weak var btn_more: BasePoppinsRegularButton!
    
    
    //MARK: TABLE VIEW SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
        self.selectionStyle = .none
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.img_view_notification.makeRounded()
        self.btn_more.removeText()
        self.btn_more.setStyleWithout(border: true, backgroundColor: .clear)
        self.img_view_height.constant = UtilityManager().getPropotionalHeight(baseHeight: 812, height: 50)
    }
    
    func setupData(organization_profile_picture: String?, message: String, date: String) {
        
        self.lbl_title.text = message
        self.lbl_date_time.text = date
        
        if let image_url = organization_profile_picture, let url = URL(string: image_url) {
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            self.img_view_notification.sd_imageIndicator = customIndicator
            self.img_view_notification.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_view_notification.image = UIImage(named: AssetsImage.placeholder)
        }
        
    }
    
    // MARK:  IBACTIONS
    
    @IBAction func btnMorePressed(_ sender: BasePoppinsRegularButton) {
        
        if self.didMorePressedBlock != nil {
            self.didMorePressedBlock(sender.row, sender.section)
        }
    }
}
