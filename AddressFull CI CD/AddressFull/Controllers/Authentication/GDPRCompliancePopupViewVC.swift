//
//  GDPRCompliancePopupViewVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 31/10/23.
//

import UIKit

class GDPRCompliancePopupViewVC: UIViewController {
    
    
    // MARK: - OBJECTS & OUTLETS
    
    var is_from_login = true
    var is_for_popia = false
    var is_agreed_terms = false
    
    @IBOutlet weak var btn_checkbox: UIButton!
    @IBOutlet weak var lbl_terms_condition: AFLabelRegular!
    @IBOutlet weak var btn_agree_gdpr: BaseBoldButton!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var lbl_content: AFLabelRegular!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(isWithBackOption: true,
                                               isWithRightOption: false,
                                               isWithQROption: false)
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.btn_agree_gdpr.setTitle(LocalText.GDPRCompliance().agree(), for: .normal)
        self.btn_agree_gdpr.setStyle(bg_color: AppColor.primary_green().withAlphaComponent(0.15),
                                     title_color: AppColor.primary_green())
        self.btn_agree_gdpr.isUserInteractionEnabled = false
        self.btn_agree_gdpr.isHidden = !self.is_from_login
        
        self.lbl_content.textColor = AppColor.text_grey_color()
        
        self.lbl_terms_condition.text = self.is_for_popia ? LocalText.POPIACompliance().popia_terms_and_condition() :  LocalText.GDPRCompliance().gdpr_terms_and_condition()
        
        self.lbl_terms_condition.isHidden = !self.is_from_login
        
        self.btn_checkbox.setImage(UIImage(named: AssetsImage.checkbox_unchecked), for: .normal)
        self.btn_checkbox.isHidden = !self.is_from_login
        
        self.lbl_content.setAttributedString(str: self.is_for_popia ? LocalText.POPIACompliance().popia_content() : LocalText.GDPRCompliance().gdpr_content(),
                                             attributedStr: [self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_one() : LocalText.GDPRCompliance().gdpr_content_title_one(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_two() : LocalText.GDPRCompliance().gdpr_content_title_two(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_three() : LocalText.GDPRCompliance().gdpr_content_title_three(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_four() : LocalText.GDPRCompliance().gdpr_content_title_four(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_five() : LocalText.GDPRCompliance().gdpr_content_title_five(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_six() : LocalText.GDPRCompliance().gdpr_content_title_six(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_seven() : LocalText.GDPRCompliance().gdpr_content_title_seven(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_eight() : LocalText.GDPRCompliance().gdpr_content_title_eight(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_nine() : LocalText.GDPRCompliance().gdpr_content_title_nine(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_ten() : LocalText.GDPRCompliance().gdpr_content_title_ten(),
                                                             self.is_for_popia ? LocalText.POPIACompliance().popia_content_title_eleven() : LocalText.GDPRCompliance().gdpr_content_title_eleven()],
                                             font: AppFont.helvetica_bold, size: 16)
        
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnCheckboxPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            
            self.is_agreed_terms = !self.is_agreed_terms
            
            self.btn_checkbox.setImage(UIImage(named: self.is_agreed_terms ? AssetsImage.checkbox_checked : AssetsImage.checkbox_unchecked), for: .normal)
            
            self.btn_agree_gdpr.isUserInteractionEnabled = self.is_agreed_terms
            self.btn_agree_gdpr.setStyle(bg_color: self.is_agreed_terms
                                         ? nil
                                         : AppColor.primary_green().withAlphaComponent(0.15),
                                         title_color: self.is_agreed_terms
                                         ? nil
                                         : AppColor.primary_green())
        }
    }
    
    @IBAction func btnAgreeClicked(_ sender: BaseBoldButton) {
        self.navigateTo(.signup_vc(is_for_login: false))
    }
}
