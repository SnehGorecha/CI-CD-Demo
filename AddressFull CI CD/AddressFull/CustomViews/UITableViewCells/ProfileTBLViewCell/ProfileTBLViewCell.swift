//
//  ProfileTBLViewCell.swift
//  AddressFull
//
//  Created by Sneh on 11/27/23.
//

import UIKit

class ProfileTBLViewCell: UITableViewCell {

    // MARK: - OBJECTS & OUTLETS
    
    var did_profile_picture_button_clicked_block: (() -> Void)!
    
    @IBOutlet weak var img_view_user_profile: UIImageView!
    
    
    // MARK: - CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - COMMON FUNCTION
    
    func setupUI() {
       
        self.selectionStyle = .none
        
        let data = UserDetailsModel.shared.image
        if let img = UIImage(data: data) {
            self.img_view_user_profile.image = img
        }
        
        DispatchQueue.main.async {
            self.img_view_user_profile.makeRounded()
            self.img_view_user_profile.clipsToBounds = true
        }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func btnProfilePictureClicked(_ sender: UIButton) {
        if self.did_profile_picture_button_clicked_block != nil {
            self.did_profile_picture_button_clicked_block()
        }
    }
}
