//
//  DataSubjectAccessRequestVC.swift
//  AddressFull
//
//  Created by Sneh on 26/02/24.
//

import UIKit

class DataSubjectAccessRequestVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var lbl_dsar_full_form: AFLabelBold!
    @IBOutlet weak var lbl_dsar: AFLabelBold!
//    @IBOutlet weak var lbl_download_description: AFLabelRegular!
    @IBOutlet weak var lbl_dsar_description: AFLabelLight!
    @IBOutlet weak var btn_download_report: BaseBoldButton!
    @IBOutlet weak var navigation_bar: UIView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.DataSubjectAccessRequest().dsar_description_title(),
                                               isWithBackOption: true)
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.setupLocalText()
        self.view.backgroundColor = .white
    }
    
    func setupLocalText() {
        self.lbl_dsar.text = LocalText.DataSubjectAccessRequest().dsar()
        self.lbl_dsar_full_form.text = LocalText.DataSubjectAccessRequest().dsar_description_title()
        self.btn_download_report.setTitle(LocalText.DataSubjectAccessRequest().download_report(), for: .normal)
//        self.lbl_download_description.text = LocalText.DataSubjectAccessRequest().download_description()
        self.lbl_dsar_description.setAttributedString(str: LocalText.DataSubjectAccessRequest().dsar_description(), attributedStr: [LocalText.DataSubjectAccessRequest().dsar_description_title()], font: AppFont.helvetica_bold, size: 16)
    }
    
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnDownloadReportPressed(_ sender: BaseBoldButton) {
        
        if GlobalVariables.shared.sync_data_completed {
            
            HomeViewModel().downloadSharedDataReportApiCall(view_for_progress_indicator: self.view)
            { is_success, model in
                if is_success , let pdf_url = model?.data?.link {
                    self.navigateTo(.document_viewer_vc(pdf_url: pdf_url ))
                } else {
                    UtilityManager().showToast(message: model?.message ?? "")
                }
            }
        } else {
            UtilityManager().showToast(message: LocalText.Synchronization().profile_data_synchronization())
        }
    }
}
