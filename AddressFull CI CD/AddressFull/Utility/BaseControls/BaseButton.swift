//
//  BaseButton.swift
//  Authentication
//
//  Created by MacBook Pro  on 13/09/23.
//

import UIKit


/// BaseButton class will used to setup custom button with customisation, Like, Font related thing UIButton's UI changes
class BasePoppinsRegularButton: UIButton {
    
    var section = 0
    var row = 0
    var is_button_selected = false
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }
    
    
    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        let font = UIFont(name: AppFont.helvetica_regular, size: 16.0)
        self.setupFontSize(font: font)
        self.setTitleColor(.black, for: .normal)
    }
}


class BaseBoldButton: UIButton {
    
    var section = 0
    var row = 0
    var is_button_selected = false
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setFontSize()
    }

    /// This function will set font size as per the detected devicedynamically
    func setFontSize() {
        let font = UIFont(name: AppFont.helvetica_bold, size: 14.0)
        self.setupFontSize(font: font)
        self.setTitleColor(.white, for: .normal)
    }
}


fileprivate extension UIButton {
    
    func setupFontSize(font : UIFont?) {
        
        if let name = font?.fontName , let size = font?.pointSize {
            
            if DeviceSize.IS_IPHONE_4_5_5S_SE_5C || DeviceSize.IS_IPHONE_4_5_5S_SE_5C {
                self.titleLabel?.font = UIFont(name: name, size: size - 2.0)
            }
            else if DeviceSize.IS_IPHONE_6_7_6S_7_8 {
                self.titleLabel?.font = UIFont(name: name, size: size - 2.0)
            }
            else if DeviceSize.IS_IPHONE_6P_7P_8PFAMILY {
                self.titleLabel?.font = UIFont(name: name, size: size + 1.0)
            }
        }
        
        self.setStyle()
    }
}



class OutlineFloatingTextField: UIView {
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let floatingPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.0 // Initially transparent
        return label
    }()

    private var isEditing = false {
        didSet {
            animatePlaceholder()
        }
    }

    var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
            animatePlaceholder()
        }
    }

    var placeholder: String? {
        get {
            return floatingPlaceholderLabel.text
        }
        set {
            floatingPlaceholderLabel.text = newValue
            floatingPlaceholderLabel.sizeToFit()
        }
    }

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(textField)
        addSubview(floatingPlaceholderLabel)

        // Configure text field
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        // Constraints
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        floatingPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        floatingPlaceholderLabel.bottomAnchor.constraint(equalTo: textField.topAnchor).isActive = true

        // Observe keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func textFieldDidChange() {
        isEditing = !textField.text!.isEmpty
    }

    private func animatePlaceholder() {
        UIView.animate(withDuration: 0.2) {
            self.floatingPlaceholderLabel.alpha = self.isEditing ? 1.0 : 0.0
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        // Move the view up when the keyboard is displayed
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.frame.origin.y = -keyboardFrame.height
        }
    }

    @objc private func keyboardWillHide() {
        // Reset the view's position when the keyboard is hidden
        self.frame.origin.y = 0
    }
}
