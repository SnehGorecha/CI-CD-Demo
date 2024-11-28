//
//  SharedDataDetailsTblViewCell.swift
//  AddressFull
//
//  Created by Sneh on 21/12/23.
//

import UIKit

class SharedDataDetailsTblViewCell: UITableViewCell {

    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var top_constaint_type_of_value: NSLayoutConstraint!
    @IBOutlet weak var img_twitter: UIImageView!
    @IBOutlet weak var img_linkedin: UIImageView!
    @IBOutlet weak var view_image: UIView!
    @IBOutlet weak var view_top_label: UIView!
    @IBOutlet var lbl_value: [AFLabelLight]!
    @IBOutlet weak var lbl_type_of_value: AFLabelLight!
    @IBOutlet weak var view_bottom_label: UIView!
    @IBOutlet weak var view_top_right_label: UIView!
    @IBOutlet weak var view_top_left_label: UIView!
    
    
    // MARK: - CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - COMMON FUNCTION
    
    func setupUI(is_right_label_hidden: Bool?) {
        self.selectionStyle = .none
        self.layer.masksToBounds = false
        self.view_top_right_label.isHidden = is_right_label_hidden ?? true
        self.view_bottom_label.isHidden = !(is_right_label_hidden ?? false)
        self.view_image.isHidden = is_right_label_hidden != nil
        self.view_top_label.isHidden = is_right_label_hidden == nil
    }
    
    func setupData(shared_data_model: SharedDataModel?,
                   linked_in_hidden: Bool = true,
                   twitter_hidden: Bool = true,
                   is_for_header: Bool = false) {
        
        self.lbl_value.forEach { lbl_value in
            lbl_value.text = shared_data_model?.value
        }
        
        self.lbl_type_of_value.text = shared_data_model?.type_of_value
        self.lbl_type_of_value.textColor = is_for_header ? .black : AppColor.text_grey_color()
        self.top_constaint_type_of_value.constant = is_for_header ? 8.0 : 0.0
        
        if let font = UIFont(name: is_for_header ? AppFont.helvetica_bold : AppFont.helvetica_regular, size: is_for_header ? 16.0 : 14.0) {
            self.lbl_type_of_value.font = font
        }
        
        self.img_twitter.image = UIImage(named: AssetsImage.twitter)
        self.img_linkedin.image = UIImage(named: AssetsImage.linkedin)
        self.img_twitter.isHidden = twitter_hidden
        self.img_linkedin.isHidden = linked_in_hidden
    }
    
}
