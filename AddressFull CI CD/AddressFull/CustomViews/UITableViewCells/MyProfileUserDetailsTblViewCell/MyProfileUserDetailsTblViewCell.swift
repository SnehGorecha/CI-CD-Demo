//
//  MyProfileUserDetailsTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit

class MyProfileUserDetailsTblViewCell: UITableViewCell {

    
    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var img_edit: UIImageView!
    @IBOutlet weak var img_vIew_user_profile: UIImageView!
    @IBOutlet weak var stack_view_first_name: UIStackView!
    @IBOutlet weak var lbl_name: AFLabelBold!
    @IBOutlet weak var lbl_mobile_number: AFLabelRegular!
    @IBOutlet weak var lbl_email: AFLabelRegular!
    
    var did_profile_picture_button_clicked_block : (() -> Void)?
    
    //MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI(profile_model: PersonalDetailsModel,
                 is_from_login : Bool = true,
                 is_edit_mode : Bool = false) {
        
        self.selectionStyle = .none
        
        if let img = profile_model.image , img != Data() {
            self.img_vIew_user_profile.image = UIImage(data: img)
        } else {
            self.img_vIew_user_profile.image = UIImage(named: AssetsImage.profile_placeholder)
        }
        
        self.img_vIew_user_profile.makeRounded(radius: 60)
        self.lbl_name.text = "\(UserDetailsModel.shared.first_name) \(UserDetailsModel.shared.last_name)"
        self.lbl_mobile_number.text = "\(UserDetailsModel.shared.country_code.dialCode()) \(UserDetailsModel.shared.mobile_number)"
        
        self.stack_view_first_name.isHidden = is_from_login
        
        self.img_edit.isHidden = !is_edit_mode
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func btnImagePressed(_ sender: UIButton) {
        if let did_profile_picture_button_clicked_block = self.did_profile_picture_button_clicked_block {
            did_profile_picture_button_clicked_block()
        }
    }
}
