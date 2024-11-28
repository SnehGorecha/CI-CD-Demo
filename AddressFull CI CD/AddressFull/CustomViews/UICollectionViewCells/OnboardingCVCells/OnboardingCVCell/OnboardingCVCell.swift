//
//  OnboardingCVCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import UIKit

class OnboardingCVCell: UICollectionViewCell {

    // MARK: OBJECTS & OUTLETS

    @IBOutlet weak var last_img_view: UIImageView!
    @IBOutlet weak var img_view: UIImageView!
    @IBOutlet weak var lbl_title: AFLabelLight!
    
    
    // MARK: COLLECTION VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: COMMON FUNCTION
    
    
    func setupData(model: OnboardingModel) {
        self.lbl_title.text = model.title
        
        if let _ = model.first_button_title {
            self.img_view.isHidden = true
            self.last_img_view.isHidden = false
            self.last_img_view.image = UIImage(named: model.image)
        }
        else {
            self.img_view.isHidden = false
            self.last_img_view.isHidden = true
            self.img_view.image = UIImage(named: model.image)
        }
    }
}
