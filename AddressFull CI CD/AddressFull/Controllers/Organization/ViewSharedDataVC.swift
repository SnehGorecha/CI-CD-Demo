//
//  ViewSharedDataVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 21/11/23.
//

import UIKit
import SDWebImage

class ViewSharedDataVC: BaseViewController {
    
    // MARK: OBJECTS & OUTLETS
    
    var organization_model : OrganizationListModel?
    var stack_view_shared_details = UIStackView()
    var user_profile_model = PersonalDetailsModel(
        first_name: ProfileDataModel(type_of_field: LocalText.Profile().first_name(),
                                     type_of_value: LocalText.Profile().first_name(),
                                     value: ""),
        last_name: ProfileDataModel(type_of_field: LocalText.Profile().last_name(),
                                    type_of_value: LocalText.Profile().last_name(),
                                    value: ""),
        image: Data(),
        arr_mobile_numbers: [ProfileDataModel(
            type_of_field: LocalText.PersonalDetails().mobile_number(),
            type_of_value: LocalText.PersonalDetails().primary(),
            value: UserDetailsModel.shared.mobile_number,
            country_code: Country.getCurrentCountry()?.code)],
        arr_email: [ProfileDataModel(type_of_field: LocalText.PersonalDetails().email(),
                                     type_of_value: LocalText.PersonalDetails().primary(),
                                     value: "")],
        arr_address: [ProfileDataModel(type_of_field: LocalText.PersonalDetails().address(),
                                       type_of_value: LocalText.PersonalDetails().home(),
                                       value: "")],
        arr_social_links: [ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                            type_of_value: LocalText.PersonalDetails().linkedin(),
                                            value: ""),
                           ProfileDataModel(type_of_field: LocalText.MyProfile().social(),
                                            type_of_value: LocalText.PersonalDetails().twitter(),
                                            value: "")]
    )
    
    @IBOutlet weak var view_shared_data: UIView!
    @IBOutlet weak var lbl_data_and_time: AFLabelBold!
    @IBOutlet weak var lbl_data_shared_on: AFLabelLight!
    @IBOutlet weak var view_seperater_two: UIView!
    @IBOutlet weak var view_seperater_one: UIView!
    @IBOutlet weak var lbl_organization_name: AFLabelRegular!
    @IBOutlet weak var img_organization: UIImageView!
    @IBOutlet weak var lbl_shared_data_to: AFLabelRegular!
    @IBOutlet weak var bg_view: UIView!
    @IBOutlet weak var btn_close: UIButton!
    
   
    // MARK: VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    // MARK: CUSTOM FUNCTIONS
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.img_organization.makeRounded()
        self.bg_view.setupLayer(cornerRadius: 14.0)
        self.view_seperater_one.backgroundColor = AppColor.seperator_gray()
        self.view_seperater_two.backgroundColor = AppColor.seperator_gray()
        self.localTextSetup()
        self.tblViewSharedDataSetup()
        self.setupStackView()
    }
    
    func localTextSetup() {
        self.lbl_data_shared_on.text = LocalText.ShareData().data_shared_on()
        self.lbl_shared_data_to.text = "\(LocalText.ShareData().shared()) \(LocalText.ShareData().details())"
        self.lbl_shared_data_to.font = UIFont(name: AppFont.helvetica_regular, size: 16)
        self.lbl_shared_data_to.textColor = AppColor.primary_green()
    }
    
    func setupStackView() {
        let scroll_view = UIScrollView()
        scroll_view.showsVerticalScrollIndicator = false
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        
        self.stack_view_shared_details.axis = .vertical
        self.stack_view_shared_details.alignment = .fill
        self.stack_view_shared_details.distribution = .fillProportionally
        self.stack_view_shared_details.translatesAutoresizingMaskIntoConstraints = false
        self.stack_view_shared_details.spacing = 1.0
        
        scroll_view.addSubview(self.stack_view_shared_details)
        self.view_shared_data.addSubview(scroll_view)
        
        let contentG = scroll_view.contentLayoutGuide
        let frameG = scroll_view.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            
            scroll_view.topAnchor.constraint(equalTo: self.view_shared_data.topAnchor),
            scroll_view.leadingAnchor.constraint(equalTo: self.view_shared_data.leadingAnchor),
            scroll_view.trailingAnchor.constraint(equalTo: self.view_shared_data.trailingAnchor),
            scroll_view.bottomAnchor.constraint(equalTo: self.view_shared_data.bottomAnchor),
            scroll_view.widthAnchor.constraint(equalToConstant: self.view_shared_data.frame.width),
            scroll_view.heightAnchor.constraint(equalToConstant: self.view_shared_data.frame.height),
            
            self.stack_view_shared_details.topAnchor.constraint(equalTo: contentG.topAnchor),
            self.stack_view_shared_details.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
            self.stack_view_shared_details.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
            self.stack_view_shared_details.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
            self.stack_view_shared_details.widthAnchor.constraint(equalTo: frameG.widthAnchor)
        ])
    }
    
    func tblViewSharedDataSetup() {
        
        let shared_data_list_model = SharedDataListModel(id: self.organization_model?.organizationId,
                                                         organization_profile_image: self.organization_model?.organization_profile_image,
                                                         organization_name: self.organization_model?.organization_name,
                                                         shared_data_timestamp: self.organization_model?.shared_data_timestamp,
                                                         mobile_number: self.organization_model?.shared_mobile_number,
                                                         email_id: self.organization_model?.shared_email_address,
                                                         address: self.organization_model?.shared_address,
                                                         shared_social_data: self.organization_model?.shared_social_data)
        
        if let data = ProfileViewModel().retrieveLoggedUserPersonalDetails(country_code: UserDetailsModel.shared.country_code, mobile_number: UserDetailsModel.shared.mobile_number) {
            self.user_profile_model = data
        }
        
        if let image_url = shared_data_list_model.organization_profile_image, let url = URL(string: image_url) {
            let customIndicator = SDWebImageActivityIndicator()
            customIndicator.startAnimatingIndicator()
            self.img_organization.sd_imageIndicator = customIndicator
            self.img_organization.sd_setImage(with: url, placeholderImage: UIImage(named: AssetsImage.placeholder))
        } else {
            self.img_organization.image = UIImage(named: AssetsImage.placeholder)
        }
        
        
        self.lbl_organization_name.text = shared_data_list_model.organization_name
        self.lbl_data_and_time.text = shared_data_list_model.shared_data_timestamp
        self.lbl_organization_name.font = UIFont(name: AppFont.helvetica_regular, size: 16)
        
        SharedData().setupStackViewData(stack_view_shared_details: self.stack_view_shared_details,
                                shared_data_list_model: shared_data_list_model,
                                user_profile_model: self.user_profile_model)
        
    }
    
    // MARK: BUTTON'S ACTIONS
    
    @IBAction func btnClosePressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
