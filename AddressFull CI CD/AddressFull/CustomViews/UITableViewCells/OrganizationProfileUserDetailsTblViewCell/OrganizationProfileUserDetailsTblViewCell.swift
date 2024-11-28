//
//  OrganizationProfileUserDetailsTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit
import SDWebImage

class OrganizationProfileUserDetailsTblViewCell: UITableViewCell {
    
    
    // MARK: OBJECTS & OUTLETS
    
    var is_reset_selected : Bool?
    var did_tap_share_my_profile_block : (() -> Void)?
    var did_tap_more_button_block : (() -> Void)?
    var did_tap_reset_select_all_button_block : ((Bool) -> Void)?
    
    @IBOutlet weak var card_view: UIView!
//    @IBOutlet weak var lbl_please_select_checkbox: AFLabelRegular!
    @IBOutlet weak var img_view_user_profile: UIImageView!
    @IBOutlet weak var lbl_organization_name: AFLabelBold!
    @IBOutlet weak var lbl_email: AFLabelRegular!
//    @IBOutlet weak var img_view_reset: UIImageView!
//    @IBOutlet weak var lbl_reset: AFLabelRegular!
//    @IBOutlet weak var btn_reset: BasePoppinsRegularButton!
    @IBOutlet weak var img_view_select_all: UIImageView!
    @IBOutlet weak var lbl_select_all: AFLabelRegular!
    @IBOutlet weak var btn_select_all: BasePoppinsRegularButton!
    @IBOutlet weak var btn_more: BasePoppinsRegularButton!
    @IBOutlet weak var view_share_my_profile: UIView!
    @IBOutlet weak var view_select_all: UIView!
    @IBOutlet weak var lbl_website: AFLabelRegular!
    @IBOutlet weak var btn_share_my_profile: BaseBoldButton!
    
    
    
    //MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI(isTopTrustedOrganization: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI(isTopTrustedOrganization: Bool,is_select_all_enabled : Bool = true) {
        
        self.selectionStyle = .none
        
        self.view_share_my_profile.isHidden = !isTopTrustedOrganization
        self.view_select_all.isHidden = isTopTrustedOrganization
        
        self.resetSelectAllCheckmarkSetupUI(isResetSelected: self.is_reset_selected)
        
//        self.lbl_reset.text = LocalText.OrganizationProfile().unselect_all()
//        self.btn_reset.setStyle(withGrayBackground: false, cornerRadius: 0.0)
        
        self.lbl_select_all.text = LocalText.OrganizationProfile().select_all()
        self.btn_select_all.setStyle(withGrayBackground: false, cornerRadius: 0.0)
        
//        self.btn_reset.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 0.0)
        self.btn_select_all.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 0.0)
        self.btn_select_all.isUserInteractionEnabled = is_select_all_enabled
        
//        self.btn_reset.backgroundColor = .clear
        self.btn_select_all.backgroundColor = .clear
        self.img_view_user_profile.makeRounded()
        
        self.btn_share_my_profile.setStyle()
        self.btn_more.setStyle(withClearBackground: true,border_color: .clear)
        
//        self.btn_reset.removeText()
        self.btn_select_all.removeText()
        self.btn_more.removeText()
        
        self.card_view.setupLayer(cornerRadius: 14)
        self.card_view.backgroundColor = .white
        self.card_view.layer.shadowColor = UIColor.black.cgColor
        self.card_view.layer.shadowOpacity = 0.2
        self.card_view.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.card_view.layer.shadowRadius = 2
        self.card_view.layer.masksToBounds = false
        
    }
    
    func setupData(organization_model : OrganizationListModel) {
        self.lbl_organization_name.text = organization_model.organization_name
        self.lbl_email.text = organization_model.email_id?.first
        self.lbl_website.text = organization_model.organization_website
        
       
        let consenting_text = "\(LocalText.OrganizationProfile().please_select_check_box_and_share_your_data()) \(organization_model.organization_name ?? "") in compliance with \(organization_model.privacy_policy?.rule ?? "") regulations, which adhere to principles of \(organization_model.privacy_policy?.sub_rules?.first ?? "")"
        
//        self.lbl_please_select_checkbox.setAttributedString(str: consenting_text,
//                                                            attributedStr: [
//                                                                organization_model.organization_name ?? "",
//                                                                organization_model.privacy_policy?.rule ?? "",
//                                                                organization_model.privacy_policy?.sub_rules?.first ?? ""
//                                                            ],
//                                                            font: AppFont.helvetica_bold,
//                                                            size: 16)
        
        
        if let image_url = organization_model.organization_profile_image, let url = URL(string: image_url) {
            
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            
            self.img_view_user_profile.sd_imageIndicator = customIndicator
            self.img_view_user_profile.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        }
        
        self.btn_share_my_profile.setTitle(LocalText.OrganizationProfile().share_my_profile(), for: .normal)
    }
    
    
    fileprivate func resetSelectAllCheckmarkSetupUI(isResetSelected: Bool?) {
        self.is_reset_selected = isResetSelected
//        self.img_view_reset.image = UIImage(named: isResetSelected ?? false ? AssetsImage.checkbox_checked : AssetsImage.checkbox_unchecked)
        self.img_view_select_all.image = UIImage(named: isResetSelected ?? true ? AssetsImage.checkbox_unchecked : AssetsImage.checkbox_checked)
    }
    
    // MARK:  IBACTIONS
    
    @IBAction func btn_reset_pressed(_ sender: BasePoppinsRegularButton) {
        self.resetSelectAllCheckmarkSetupUI(isResetSelected: true)
        
        if let did_tap_reset_select_all_button_block = self.did_tap_reset_select_all_button_block {
            did_tap_reset_select_all_button_block(true)
        }
    }
    
    @IBAction func btn_select_all_pressed(_ sender: BasePoppinsRegularButton) {
        self.resetSelectAllCheckmarkSetupUI(isResetSelected: false)
        
        if let did_tap_reset_select_all_button_block = self.did_tap_reset_select_all_button_block {
            did_tap_reset_select_all_button_block(false)
        }
    }
    
    @IBAction func btnShareMyProfilePressed(_ sender: BaseBoldButton) {
        if let did_tap_share_my_profile_block = self.did_tap_share_my_profile_block {
            did_tap_share_my_profile_block()
        }
    }
    
    @IBAction func btnMorePressed(_ sender: BasePoppinsRegularButton) {
        if let did_tap_more_button_block = self.did_tap_more_button_block {
            did_tap_more_button_block()
        }
    }
}
