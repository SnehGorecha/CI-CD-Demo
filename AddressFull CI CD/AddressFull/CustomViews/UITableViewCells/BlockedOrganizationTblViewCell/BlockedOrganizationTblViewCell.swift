//
//  BlockedOrganizationTblViewCell.swift
//  AddressFull
//
//  Created by Sneh on 05/01/24.
//

import UIKit
import SDWebImage

class BlockedOrganizationTblViewCell: UITableViewCell {

    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var lbl_date_time: AFLabelLight!
    @IBOutlet weak var lbl_organization_name: AFLabelRegular!
    @IBOutlet weak var btn_unblock: BaseBoldButton!
    @IBOutlet weak var img_organization_profile: UIImageView!
    @IBOutlet weak var bg_view: UIView!
    
    var did_unblock_button_pressed_block : (() -> Void)!
    
    
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
        self.img_organization_profile.makeRounded()
        self.btn_unblock.setTitle(LocalText.BlockOrganization().unblock(), for: .normal)
        self.btn_unblock.setStyle()
        self.btn_unblock.setupLayer(cornerRadius: 8)
    }
    
    func setupData(model : OrganizationListModel) {
        
        self.lbl_organization_name.text = model.organization_name
        self.lbl_date_time.text = model.blocked_date_time

        if let image_url = model.organization_profile_image, let url = URL(string: image_url) {
            
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            
            self.img_organization_profile.sd_imageIndicator = customIndicator
            self.img_organization_profile.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_organization_profile.image = UIImage(named: AssetsImage.placeholder)
        }
        
    }
    
    // MARK: IBACTIONS
    
    @IBAction func btnUnblockPressed(_ sender: BaseBoldButton) {
        if let did_unblock_button_pressed_block = did_unblock_button_pressed_block {
            did_unblock_button_pressed_block()
        }
    }
}
