//
//  TopTrustedOrganizationTBLViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 01/11/23.
//

import UIKit
import SDWebImage

class TopTrustedOrganizationTBLViewCell: UITableViewCell {

   
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var btn_count: UIButton!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var img_view_top_trusted_organization: UIImageView!
    @IBOutlet weak var lbl_organization_name: AFLabelRegular!
    @IBOutlet weak var btn_more: BasePoppinsRegularButton!
    
    var did_more_button_pressed_block : (() -> Void)?
    
    // MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: CUSTOM FUNCTIONS
    
    func setupUI(border_color : UIColor = .clear) {
        
        self.selectionStyle = .none
        
        self.bg_view.backgroundColor = .white
        self.bg_view.setupLayer(borderColor: border_color, borderWidth: 1, cornerRadius: 14.0)
        self.img_view_top_trusted_organization.makeRounded()
        self.img_view_top_trusted_organization.contentMode = .scaleAspectFill
        self.btn_more.removeText()
        self.btn_more.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 0.0)
        self.btn_more.backgroundColor = .clear
        
        self.btn_count.makeRounded()
        self.btn_count.backgroundColor = AppColor.primary_green()
        self.btn_count.setTitleColor(.white, for: .normal)
    }
    
    func setupData(model: OrganizationListModel,is_my_trusted: Bool) {
        self.lbl_organization_name.text = model.organization_name

        self.btn_more.isHidden = !is_my_trusted
        self.btn_count.setTitle(String(model.shared_data_count ?? 0), for: .normal)
        self.btn_count.isHidden = true
       
        
        if let image_url = model.organization_profile_image, let url = URL(string: image_url) {
            
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            
            self.img_view_top_trusted_organization.sd_imageIndicator = customIndicator
            self.img_view_top_trusted_organization.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_view_top_trusted_organization.image = UIImage(named: AssetsImage.placeholder)
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func btnMorePressed(_ sender: BasePoppinsRegularButton) {
        if let did_more_button_pressed_block = self.did_more_button_pressed_block {
            did_more_button_pressed_block()
        }
    }
}
