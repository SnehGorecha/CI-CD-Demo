//
//  ScannerVC.swift
//  AddressFull
//
//  Created by Sneh on 12/12/23.
//

import UIKit
import AVFoundation


class ScannerVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var image_completion_block : ((_ image : UIImage?) -> Void)!
    var did_scan_block : ((_ is_success : Bool,_ scanned_data : [String:Any]?) -> Void)!
    var is_qr_code_scanned : Bool = false
    
    @IBOutlet weak var btn_select_from_gallery: UIButton!
    @IBOutlet weak var lbl_align_scanner: AFLabelBold!
    @IBOutlet weak var navigation_view: UIView!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var view_top: UIView!
    @IBOutlet weak var view_scanner: UIView!
    @IBOutlet weak var view_bottom: UIView!
    @IBOutlet weak var view_right: UIView!
    @IBOutlet weak var view_left: UIView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupUI()
    }
    
    // MARK: - COMMON FUNCTION
    
    func setupUI() {
        self.navigation_bar.navigationBarSetup(isWithBackOption: true,
                                               isWithRightOption: false,
                                               isWithQROption: false)
        self.view_scanner.setupLayer(borderColor: .white, borderWidth: 1)
        self.setupViews()
        self.setupScanner()
        self.setupLocalText()
    }
    
    func setupViews() {
        let bg_color = AppColor.primary_gray().withAlphaComponent(0.5)
        self.view_top.backgroundColor = bg_color
        self.view_left.backgroundColor = bg_color
        self.view_right.backgroundColor = bg_color
        self.view_bottom.backgroundColor = bg_color
        self.navigation_view.backgroundColor = bg_color
    }
    
    func setupLocalText() {
        self.lbl_align_scanner.text = LocalText.Scanner().align_qr_code()
        self.btn_select_from_gallery.setTitle(LocalText.Scanner().select_from_gallery(), for: .normal)
        self.btn_select_from_gallery.titleLabel?.font = UIFont(name: AppFont.helvetica_bold, size: 14)
        self.btn_select_from_gallery.setCorner(radius: 14, toCorners: .allCorners)
    }
    
    
    // MARK: Get back camera device
    func setupScanner() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            self.showPopupAlert(title: Message.failed_to_open_camera(),
                                message: nil,
                                leftTitle: nil,
                                rightTitle: LocalText.AlertButton().ok(),
                                close_button_hidden: true,
                                didPressedLeftButton: nil,
                                didPressedRightButton: nil)
            return
        }
        
        self.addVideoLayer(captureDevice: captureDevice)
    }
    
    
    // MARK: Add video layer
    func addVideoLayer(captureDevice : AVCaptureDevice) {
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            //MARK: set output type
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            //MARK: Video capture view
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = self.view.layer.bounds
            
            DispatchQueue.main.async {
                self.view.layer.addSublayer(self.videoPreviewLayer!)
            }
            
            self.setupViewsToFront()
            
        } catch(let err) {
            print("Error in QR scanner : - ",err)
        }
    }
    
    
    // MARK: Set up views to front
    func setupViewsToFront() {
        
        DispatchQueue.main.async {
            self.view.bringSubviewToFront(self.view_scanner)
            self.view.bringSubviewToFront(self.view_top)
            self.view.bringSubviewToFront(self.view_left)
            self.view.bringSubviewToFront(self.view_right)
            self.view.bringSubviewToFront(self.view_bottom)
            self.view.bringSubviewToFront(self.navigation_view)
            self.view.bringSubviewToFront(self.navigation_bar)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }
    
    
    func checkPhotoFromGallery(image: UIImage) {
        let detector:CIDetector=CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
        
        let ciImage: CIImage = CIImage(image:image)!
        var qrCodeLink = ""
        let features = detector.features(in: ciImage)
        for feature in features as! [CIQRCodeFeature] {
            qrCodeLink += feature.messageString!
        }
        
        let decodedData = Data(base64Encoded: qrCodeLink)
        let decodedString = String(data: decodedData ?? Data(), encoding: .utf8)
        self.checkSelectedQRData(qr_data: decodedString,is_image_selected: true)
        
    }
    
    
    func checkSelectedQRData(qr_data : String?,is_image_selected : Bool = false) {
        self.is_qr_code_scanned = true
        if qr_data != nil {
            DispatchQueue.main.async {
                if let did_scan_block  = self.did_scan_block {
                    if let scan_data = qr_data?.toDictionary() , ((scan_data["organizationId"] as? String) != nil) {
                        
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: false)
                        }
                        
                        /// This block is used in Custom Navigation bar file.
                        did_scan_block(true,scan_data)
                        
                    } else {
                        is_image_selected ? self.showInvalidImageAlert() : self.showInvalidQRAlert()
                    }
                } else {
                    is_image_selected ? self.showInvalidImageAlert() : self.showInvalidQRAlert()
                }
            }
        } else {
            is_image_selected ? self.showInvalidImageAlert() : self.showInvalidQRAlert()
        }
    }
    
    
    // MARK: Show invalid QR alerts
    
    func showInvalidImageAlert() {
        self.showPopupAlert(title: Message.invalid_image(),
                            message: nil,
                            leftTitle: nil,
                            rightTitle: LocalText.AlertButton().ok(),
                            close_button_hidden: true,
                            didPressedLeftButton: nil,
                            didPressedRightButton: nil)
    }
    
    func showInvalidQRAlert() {
        if !self.is_qr_code_scanned {
            
            self.is_qr_code_scanned = true
            
            self.showPopupAlert(title: Message.invalid_qr(),
                                message: nil,
                                leftTitle: nil,
                                rightTitle: LocalText.AlertButton().try_again(),
                                close_button_hidden: true,
                                didPressedLeftButton: nil,
                                didPressedRightButton: {
                self.dismiss(animated: true)
                self.is_qr_code_scanned = false
            })
        }
    }
    
    
    // MARK: - BUTTON'S ACTIONS
    
    @IBAction func btnSelectFromGalleryPressed(_ sender: UIButton) {
        
        self.view.showProgressBar()
        
        let imagePicker = UIImagePickerController()
        
        if #available(iOS 14, *) {
            PermissionManager.shared.defaultAlertTitle = AppInfo.app_name
            PermissionManager.shared.checkPermission(for: [.photoLibrary], parentController: self) {
                
                DispatchQueue.main.async {
                    imagePicker.delegate = self
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.modalPresentationStyle = .currentContext
                    DispatchQueue.main.async {
                        self.present(imagePicker, animated: true) {
                            self.view.hideProgressBar()
                        }
                    }
                }
            }
        } else {
            self.showPopupAlert(title: AppInfo.app_name,
                                message: Message.upgrade_your_os_version(),
                                leftTitle: nil,
                                rightTitle: LocalText.AlertButton().ok(),
                                close_button_hidden: true,
                                didPressedLeftButton: nil,
                                didPressedRightButton: nil)
        }
    }
}


// MARK: - EXTENSION AVCAPTURE

extension ScannerVC : AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: Scan QR code
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObject.type == AVMetadataObject.ObjectType.qr {
            let barCode = videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
            if barCode!.bounds.minY >= 300 && barCode!.bounds.minY <= 500 , let encodedString = metadataObject.stringValue {
                if let decodedData = Data(base64Encoded: encodedString) {
                    if let decodedString = String(data: decodedData, encoding: .utf8) {
                        
                        /// This condition is used here to prevent multiple controllers pushing in navigation controller
                        if !self.is_qr_code_scanned {
                            self.checkSelectedQRData(qr_data: decodedString)
                        }
                    } else {
                        self.showInvalidQRAlert()
                    }
                } else {
                    self.showInvalidQRAlert()
                }
            }
        }
    }
}


// MARK: - EXTENSION IMAGE PICKER

extension ScannerVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        DispatchQueue.main.async {
            picker.dismiss(animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                picker.dismiss(animated: true)
                self.checkPhotoFromGallery(image: img)
            }
        }
    }
}
