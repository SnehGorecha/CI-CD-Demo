//
//  AddressFullTests.swift
//  AddressFullTests
//
//  Created by Sneh on 23/10/24.
//

import XCTest
@testable import AddressFull

final class AddressFullTests: XCTestCase {
    
    let sign_up_view_model = SignUpViewModel()
    
    func testLoginMobileNumberValidation() {
        // Arrange
        let sign_up_request_model_1 = SignupRequestModel(country_code: "+91", mobile_number: "9099665918", device_id: "1234567890", device_token: "123456789")
        let sign_up_request_model_2 = SignupRequestModel(country_code: "+91", mobile_number: "90996659181231234", device_id: "1234567890", device_token: "123456789")
        let sign_up_request_model_3 = SignupRequestModel(country_code: "+91", mobile_number: "", device_id: "1234567890", device_token: "123456789")
        
        // Act
        let result_1 = self.sign_up_view_model.validateSignup(requestModel: sign_up_request_model_1)
        let result_2 = self.sign_up_view_model.validateSignup(requestModel: sign_up_request_model_2)
        let result_3 = self.sign_up_view_model.validateSignup(requestModel: sign_up_request_model_3)
        
        // Assert
        XCTAssertTrue(result_1.is_success)
        XCTAssertFalse(result_2.is_success)
        XCTAssertFalse(result_3.is_success)
    }
    
    func testSignUpApi() {
        // Arrange
        let sign_up_request_model = SignupRequestModel(country_code: "91", mobile_number: "9099665918", device_id: GlobalVariables.shared.device_id, device_token: GlobalVariables.shared.fcm_token)
        
        let expectation = self.expectation(description: "API Call completes")
        
        // Act
        var result = false
        
        self.sign_up_view_model.sendOtpApiCall(signup_request_model: sign_up_request_model, is_for_login: true, view_for_progress_indicator: UIView()) { is_success, model in
            result = is_success
            expectation.fulfill()
        }
        
        // Wait for the API call to complete (with a timeout)
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                print("Expectation failed with error: \(error)")
            }
        }
        
        // Assert
        XCTAssertTrue(result)
        
    }
    
}
