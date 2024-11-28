//
//  SingleLabelCheckmarkTblViewCell.swift
//  AddressFull
//
//  Created by MacBook Pro  on 07/11/23.
//

import UIKit

class SingleLabelCheckmarkTblViewCell: UITableViewCell {
    
    
    // MARK: OBJECTS & OUTLETS
    
    @IBOutlet weak var view_switch: UIView!
    @IBOutlet weak var notification_switch: UISwitch!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var lbl_title: AFLabelRegular!
    @IBOutlet weak var img_view_checkmark: UIImageView!
    @IBOutlet weak var btn_selection: BasePoppinsRegularButton!
    
    var did_select_app_lock_block : (() -> Void)!
    var did_switch_value_changed_block : (() -> Void)!
    
    //MARK: TABLE VIEW CELL SETUP
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: CUSTOM FUNCTIONS
    
    func setupUI(is_for_notification : Bool = true) {
        self.selectionStyle = .none
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.btn_selection.removeText()
        self.btn_selection.setupLayer(borderColor: .clear, borderWidth: 0.0, cornerRadius: 0.0)
        self.btn_selection.backgroundColor = .clear
        
        self.notification_switch.transform = CGAffineTransformMakeScale(0.6, 0.5)
        
        self.view_switch.isHidden = !is_for_notification
        self.img_view_checkmark.isHidden = is_for_notification
        self.btn_selection.isHidden = is_for_notification
        
        self.notification_switch.layer.masksToBounds = true
    }
    
    func checkmarkImgViewSetup(isSelected: Bool) {
        self.img_view_checkmark.image = UIImage(named: isSelected ? AssetsImage.rounded_green_checked : AssetsImage.rounded_unchecked)
    }
    
    func dataSetup(model: AppLockModelDelay) {
        self.lbl_title.text = model.option
        self.checkmarkImgViewSetup(isSelected: model.is_selected)
        self.notification_switch.isOn = model.is_selected
        self.notification_switch.thumbTintColor = model.is_selected ? AppColor.primary_green() : .black
        
        if let border_view = self.notification_switch.subviews[0].subviews[1] as? UIView {
            border_view.backgroundColor = .white
            border_view.layer.borderColor = model.is_selected ? AppColor.primary_green().cgColor : UIColor.black.cgColor
            border_view.layer.borderWidth = 1
        }
        
        if let img_view = (notification_switch.subviews.first?.subviews.last?.subviews.last as? UIImageView) {
            img_view.transform = CGAffineTransformMakeScale(0.9, 0.9)
        }
    }

    
    //MARK: IBACTIONS
    
    @IBAction func btnSelectionPressed(_ sender: BasePoppinsRegularButton) {
        if did_select_app_lock_block != nil {
            self.did_select_app_lock_block()
        }
    }
    
    @IBAction func switchValueChanges(_ sender: UISwitch) {
        if did_switch_value_changed_block != nil {
            self.did_switch_value_changed_block()
        }
    }
}
