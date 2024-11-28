//
//  SharedDataTblViewCell.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import UIKit
import SDWebImage

class SharedDataTblViewCell: UITableViewCell {
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var view_seperator_two: UIView!
    @IBOutlet weak var lbl_shared_date_and_time: AFLabelBold!
    @IBOutlet weak var lbl_data_shared_on: AFLabelLight!
    @IBOutlet weak var lbl_shared_data_to: AFLabelRegular!
    @IBOutlet weak var main_view: UIView!
    @IBOutlet weak var view_seperator: UIView!
    @IBOutlet weak var lbl_organization_name: AFLabelRegular!
    @IBOutlet weak var stack_view_shared_details: UIStackView!
    @IBOutlet weak var img_organization_profile: UIImageView!
    
    var completion: ((CGFloat) -> Void)?
    
    
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
        self.img_organization_profile.makeRounded()
        self.view_seperator.backgroundColor = AppColor.seperator_gray()
        self.view_seperator_two.backgroundColor = AppColor.seperator_gray()
        self.setupLocalText()
        self.setupMainView()
    }
    
    func setupMainView() {
        self.main_view.layer.cornerRadius = 14
        self.main_view.layer.shadowColor = UIColor.black.cgColor
        self.main_view.layer.shadowOpacity = 0.2
        self.main_view.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.main_view.layer.shadowRadius = 2
        self.main_view.layer.masksToBounds = false
    }
    
    func setupLocalText() {
        self.lbl_data_shared_on.text = LocalText.ShareData().data_shared_on()
        self.lbl_shared_data_to.font = UIFont(name: AppFont.helvetica_regular, size: 16)
    }
    
    func setupData(shared_data_list_model : SharedDataListModel,user_profile_model : PersonalDetailsModel) {
        
        if let image_url = shared_data_list_model.organization_profile_image, let url = URL(string: image_url) {
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            self.img_organization_profile.sd_imageIndicator = customIndicator
            self.img_organization_profile.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_organization_profile.image = UIImage(named: AssetsImage.placeholder)
        }
        
        self.lbl_organization_name.text = shared_data_list_model.organization_name
        self.lbl_shared_date_and_time.text = shared_data_list_model.shared_data_timestamp
        self.lbl_organization_name.font = UIFont(name: AppFont.helvetica_regular, size: 16)
        self.lbl_shared_data_to.text = "\(LocalText.ShareData().shared()) \(LocalText.ShareData().details())"
        self.lbl_shared_data_to.textColor = AppColor.primary_green()
        
        SharedData().setupStackViewData(stack_view_shared_details: self.stack_view_shared_details,
                                        shared_data_list_model: shared_data_list_model,
                                        user_profile_model: user_profile_model)
        
    }
}
