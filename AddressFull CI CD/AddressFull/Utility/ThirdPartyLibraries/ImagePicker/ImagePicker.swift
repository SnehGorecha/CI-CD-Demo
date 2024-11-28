//
//  ImagePicker.swift
//
//  Created by Dhanraj D. Darji.
//  Copyright © 2019 Dhanraj D. Darji. All rights reserved.
//

import UIKit


class ImagePicker: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: OBJECTS & OUTLETS
    
    var image_completion_block : ((_ image : UIImage?) -> Void)!
    var pickedCanceledBlock : ((_ isCanceled : Bool) -> Void)!
    
    //MARK: VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate  = self
        
    }
    
    open class func openImagePickerController(viewController : UIViewController, imageSourceType : UIImagePickerController.SourceType ,completion : @escaping ((_ image : UIImage?) -> Void), canceled : @escaping ((_ isCanceled : Bool) -> Void), error : @escaping ((_ message : String?) -> Void)) {

        UIApplication.topViewController()?.view.showProgressBar()
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        
        if UIImagePickerController.isSourceTypeAvailable(imageSourceType) {
            
            let vc        = self.init()
            vc.sourceType = imageSourceType
            
            vc.image_completion_block = { (img) in
                completion(img)
            }
            
            vc.pickedCanceledBlock = { (cancelFlag) in
                canceled(cancelFlag)
            }
            DispatchQueue.main.async {
                viewController.present(vc, animated: true, completion: nil)
                UIApplication.topViewController()?.view.hideProgressBar()
                UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            }
        }
        else {
            error("\(imageSourceType == .camera ? "Camera not available" : "Gallery not available")")
        }
    }

    
    //MARK: UIIMAGEPICKER CONTROLLER DELEGATE METHODS
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        if self.pickedCanceledBlock != nil {
            self.pickedCanceledBlock(true)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            if self.image_completion_block != nil {
                self.image_completion_block(img)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
