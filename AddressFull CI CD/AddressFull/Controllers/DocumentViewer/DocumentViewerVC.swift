//
//  DocumentViewerVC.swift
//  AddressFull
//
//  Created by Sneh on 05/03/24.
//

import UIKit
import PDFKit


class DocumentViewerVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    @IBOutlet weak var btn_save: BaseBoldButton!
    @IBOutlet weak var view_document: UIView!
    @IBOutlet weak var navigation_bar: UIView!
    
    var pdf_url = ""
    var pdf_view = PDFView()
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDocumentView()
        self.navigation_bar.navigationBarSetup(title: LocalText.Home().shared_data_report(),
                                               isWithBackOption: true,
                                               isWithRightOption: true,
                                               isWithQROption: false,
                                               right_image: AssetsImage.download, nil)
        {
            self.downloadDocument()
        }
        
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        
        self.localTextSetup()
    }
    
    func localTextSetup() {
        self.btn_save.setTitle(LocalText.MyProfile().save(), for: .normal)
    }
    
    func setupDocumentView() {
        self.view.showProgressBar()
        
        self.pdf_view = PDFView(frame: self.view_document.bounds)
        self.pdf_view.autoScales = true
        let file_URL = URL(string: self.pdf_url)
        
        DispatchQueue.global(qos: .background).async {
            
            let document = PDFDocument(url: file_URL!)
            
            DispatchQueue.main.async {
                
                self.pdf_view.document = document
                self.view_document.addSubview(self.pdf_view)
                self.view.hideProgressBar()
            }
        }
    }
    
    func downloadDocument() {
        
        DispatchQueue.main.async {
            
            self.view_document.showProgressBar()
            
            guard let pdf_data = self.pdf_view.document?.dataRepresentation() else {
                return
            }
            
            let activity_view_controller = UIActivityViewController(activityItems: [pdf_data], applicationActivities: nil)
            
            self.present(activity_view_controller, animated: true, completion: {
                self.view_document.hideProgressBar()
            })
        }
    }
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnSavePressed(_ sender: BaseBoldButton) {
        
        self.view_document.showProgressBar()
        
        guard let pdf_data = self.pdf_view.document?.dataRepresentation() else {
            return
        }
        
        let activity_view_controller = UIActivityViewController(activityItems: [pdf_data], applicationActivities: nil)
        
        DispatchQueue.main.async {
            self.present(activity_view_controller, animated: true, completion: {
                self.view_document.hideProgressBar()
            })
        }
    }
}
