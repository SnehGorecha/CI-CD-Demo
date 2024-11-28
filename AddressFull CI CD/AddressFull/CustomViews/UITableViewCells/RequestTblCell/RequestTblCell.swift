//
//  RequestTblCell.swift
//  AddressFull
//
//  Created by Sneh on 04/01/24.
//

import UIKit
import SDWebImage

class RequestTblCell: UITableViewCell {

    // MARK: - OBJECTS & OUTLETS
    
    var button_accept_pressed_block : (() -> Void)?
    var button_reject_pressed_block : (() -> Void)?
    
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var img_organization_profile: UIImageView!
    @IBOutlet weak var stack_view_action_height: NSLayoutConstraint!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var lbl_date_time: AFLabelRegular!
    @IBOutlet weak var btn_reject: BasePoppinsRegularButton!
    @IBOutlet weak var btn_accept: BasePoppinsRegularButton!
   
    // MARK: - TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.selectionStyle = .none
                
        self.localTextSetup()
        
        self.btn_accept.setStyleWithout(border: true, backgroundColor: AppColor.primary_green().withAlphaComponent(0.15))
        self.btn_reject.setStyleWithout(border: true, backgroundColor: AppColor.primary_red().withAlphaComponent(0.15))
        
        self.btn_accept.tintColor = AppColor.primary_green()
        self.btn_accept.setTitleColor(AppColor.primary_green(), for: .normal)
        
        self.btn_reject.tintColor = AppColor.primary_red()
        self.btn_reject.setTitleColor(AppColor.primary_red(),for: .normal)
        
        self.btn_reject.titleLabel?.font = UIFont(name: AppFont.helvetica_regular, size: 14)
        self.btn_accept.titleLabel?.font = UIFont(name: AppFont.helvetica_bold, size: 14)
        
        self.lbl_date_time.textColor = AppColor.text_grey_color()
        self.img_organization_profile.makeRounded()
        self.bg_view.setupLayer(cornerRadius: 14)

        self.stack_view_action_height.constant = UtilityManager().getPropotionalHeight(baseHeight: 812, height: 45) <= 45 ? UtilityManager().getPropotionalHeight(baseHeight: 812, height: 45) : 45
    }
    
    func localTextSetup() {
        self.btn_accept.setTitle(LocalText.Request().accept(), for: .normal)
        self.btn_reject.setTitle(LocalText.Request().reject(), for: .normal)
    }
    
    func setUpData(model: RequestListResponseModel) {
        self.lbl_title.text = model.message ?? ""
        self.lbl_date_time.text = model.request_date ?? ""
        
        if let image_url = model.organization_profile_image, let url = URL(string: image_url) {
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            self.img_organization_profile.sd_imageIndicator = customIndicator
            self.img_organization_profile.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_organization_profile.image = UIImage(named: AssetsImage.placeholder)
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func btnAcceptPressed(_ sender: BasePoppinsRegularButton) {
        if let button_accept_pressed_block = self.button_accept_pressed_block {
            button_accept_pressed_block()
        }
    }
    
    @IBAction func btnRejectPressed(_ sender: BasePoppinsRegularButton) {
        if let button_reject_pressed_block = button_reject_pressed_block {
            button_reject_pressed_block()
        }
    }
}
