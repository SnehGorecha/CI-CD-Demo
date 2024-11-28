//
//  SingleLabelTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 03/11/23.
//

import UIKit

class SingleLabelTblViewCell: UITableViewCell {

    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var view_img_icon: UIView!
    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var bg_viewWithoutLeadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var bg_viewWithoutTrailingSpaceConstraint: NSLayoutConstraint!
    
    
    //MARK: TABLE VIEW CE   LL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI(font: String? = nil, leading: CGFloat = 8.0, trailing: CGFloat = 8.0, textAlignment: NSTextAlignment = .left, withLeadingAndTrailinfSpcae: Bool = false,is_icon_hidden: Bool = true,bg_color: UIColor = .clear) {
        
        self.selectionStyle = .none
        
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.bg_view.backgroundColor = bg_color
        
        self.lbl_title.textAlignment = textAlignment
        
        self.view_img_icon.isHidden = is_icon_hidden
        
        if let newFont = font {
            self.lbl_title.font  = UIFont(name: newFont, size: self.lbl_title.font.pointSize )
        }
    }
    
    func dataSetup(_ title: String, _ image: String? = nil) {
        self.lbl_title.text = title.localized()
        self.img_icon.image = UIImage(named: image ?? "")
    }
}
