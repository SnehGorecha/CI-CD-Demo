//
//  DeleteConfirmationSuccessVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 07/11/23.
//

import UIKit

class DeleteConfirmationSuccessVC: BaseViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    fileprivate var option_selected = false
    fileprivate var image = UIImage()
    fileprivate var popup_title = ""
    fileprivate var first_option_content: String? = ""
    fileprivate var second_option_content: String? = nil
    fileprivate var third_option_content: String? = nil
    fileprivate var submit_button_title = ""
    fileprivate var no_button_title = ""
    fileprivate var submit_buttom_prefix_image: String? = nil
    fileprivate var with_close_button: Bool = true
    fileprivate var with_no_button: Bool = false
    fileprivate var with_exclamation_mark: Bool = false
    var did_submit_button_pressed_block: (() -> Void)!
    
    @IBOutlet weak var btn_no: BaseBoldButton!
    @IBOutlet weak var btn_first_checkbox: UIButton!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var btn_close: BaseBoldButton!
    @IBOutlet weak var img_view_popup: UIImageView!
    @IBOutlet weak var lbl_title: AFLabelBold!
    @IBOutlet weak var option_top_space_view: UIView!
    @IBOutlet weak var first_option_bg_view: UIView!
    @IBOutlet weak var lbl_first_option_content: AFLabelRegular!
    @IBOutlet weak var second_option_bg_view: UIView!
    @IBOutlet weak var lbl_second_option_content: AFLabelRegular!
    @IBOutlet weak var btn_submit: BaseBoldButton!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setup(image: UIImage,
               title: String,
               firstOptionContent: String? = nil,
               secondOptionContent: String? = nil,
               thirdOptionContent: String? = nil,
               submitButtonTitle: String,
               noButtonTitle: String = LocalText.AlertButton().no(),
               submitButtomPrefixImage: String? = nil,
               with_close_button: Bool = true,
               with_no_button: Bool = false,
               with_exclamation_mark: Bool = false) {
        
        self.image = image
        self.popup_title = title
        self.first_option_content = firstOptionContent
        self.second_option_content = secondOptionContent
        self.third_option_content = thirdOptionContent
        self.submit_button_title = submitButtonTitle
        self.no_button_title = noButtonTitle
        self.submit_buttom_prefix_image = submitButtomPrefixImage
        self.with_close_button = with_close_button
        self.with_no_button = with_no_button
        self.with_exclamation_mark = with_exclamation_mark
    }
    
    fileprivate func setupUI() {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.btn_close.setStyle(bg_color: .clear)
        self.btn_close.isHidden = !self.with_close_button

        self.img_view_popup.image = self.image
        self.img_view_popup.makeRounded()
//        self.lbl_title.text = self.popup_title
        
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: AssetsImage.report)
        attachment.bounds = CGRect(x: 5, y: 0, width: 15, height: 15)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: self.popup_title)
        if self.with_exclamation_mark {
            myString.append(attachmentString)
        }
        
        self.lbl_title.attributedText = myString
        
        if let first_option_content = self.first_option_content {
            self.lbl_first_option_content.text = first_option_content
            self.option_top_space_view.isHidden = false
            self.first_option_bg_view.isHidden = false
        } else if let third_option_content = self.third_option_content {
            self.lbl_first_option_content.text = third_option_content
            self.option_top_space_view.isHidden = false
            self.first_option_bg_view.isHidden = false
        }
        
        if let second_option_content = self.second_option_content {
            self.lbl_second_option_content.text = second_option_content
            self.option_top_space_view.isHidden = false
            self.second_option_bg_view.isHidden = false
        }
        
        if let submit_buttom_prefix_image = self.submit_buttom_prefix_image {
            self.btn_submit.setImage(UIImage(named: submit_buttom_prefix_image), for: .normal)
        }
        
        self.btn_submit.setTitle(self.submit_button_title, for: .normal)
        self.btn_no.setTitle(self.no_button_title, for: .normal)
        
        self.btn_submit.titleLabel?.numberOfLines = 0
        self.btn_submit.titleLabel?.textAlignment = .center
        self.btn_submit.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.btn_no.isHidden = !self.with_no_button
        
        self.btn_no.tintColor = AppColor.primary_red()
        self.btn_no.setStyle(bg_color: AppColor.primary_red().withAlphaComponent(0.15),title_color: AppColor.primary_red())
        
        self.lbl_first_option_content.textAlignment = self.third_option_content != nil ? .center : .left
        self.btn_first_checkbox.isHidden = self.third_option_content != nil
        
        if self.btn_submit.title(for: .normal) == LocalText.Settings().okay() || self.btn_submit.title(for: .normal) == LocalText.SignUpOtp().submit() || self.btn_submit.title(for: .normal) == LocalText.AlertButton().yes() || self.btn_submit.title(for: .normal) == LocalText.AlertButton().yes_i_want_to_delete_all_of_my_trusted_organizations() || self.btn_submit.title(for: .normal) == LocalText.AlertButton().yes_permanently_delete_my_account() {
            
            self.btn_submit.tintColor = AppColor.primary_green()
            self.btn_submit.setStyle()
            
        } else {
            self.btn_submit.tintColor = AppColor.primary_red()
            self.btn_submit.setStyle(bg_color: AppColor.primary_red().withAlphaComponent(0.15),title_color: AppColor.primary_red())
        }
    }
    
    // MARK: - BUTTON'S ACTION
    
    @IBAction func btnClosePressed(_ sender: BasePoppinsRegularButton) {
        self.dismiss(animated: true)
    }

    @IBAction func btnSubmitPressed(_ sender: BasePoppinsRegularButton) {
        if self.did_submit_button_pressed_block != nil {
            self.did_submit_button_pressed_block()
        }
    }
    
    @IBAction func btnNoPressed(_ sender: BaseBoldButton) {
        self.dismiss(animated: true)
    }
}
