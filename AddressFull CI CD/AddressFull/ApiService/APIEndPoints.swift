//
//  APIEndPoints.swift
//  BaseProject
//
//  Created by MacBook Pro  on 11/10/23.
//

import Foundation
import Alamofire



/// This enum is containg all api's en point with its type
enum Endpoint {
    
    case key_exchange
    case refresh_token
    case login
    case signup
    case verify_otp
    case resend_otp
    case top_trusted_organization
    case organization_profile
    case my_trusted_organization
    case delete_my_trusted_organization
    case share_data
    case request_list
    case force_update
    case accept_reject_request
    case blocked_organization_list
    case block_unblock_organization
    case read_notification
    case activity_log_list
    case activity_filters
    case delete_all_trusted_organization
    case delete_my_account
    case auto_sync
    case shared_data_report
    
    var url : String {
        switch self {
        case .key_exchange:
            return "/users/key-exchange"
        case .refresh_token:
            return "/users/refresh-token"
        case .login:
            return "/users/login"
        case .signup:
            return "/users/signup"
        case .verify_otp:
            return "/users/verify-otp"
        case .resend_otp:
            return "/users/resend-otp"
        case .top_trusted_organization:
            return "/organizations/top-trusted"
        case .organization_profile:
            return "/organizations/trusted/profile"
        case .my_trusted_organization:
            return "/organizations/my-trusted"
        case .delete_my_trusted_organization:
            return "/organizations/my-trusted"
        case .share_data:
            return "/organizations/my-trusted/share-data"
        case .request_list:
            return "/notifications"
        case .force_update:
            return "/notifications/force-update"
        case .accept_reject_request:
            return "/notifications/update-request"
        case .blocked_organization_list:
            return "/organizations/my-blocked"
        case .block_unblock_organization:
            return "/organizations/block-unblock"
        case .read_notification:
            return "/notifications/read"
        case .activity_log_list:
            return "/transactions/activity-list"
        case .activity_filters:
            return "/transactions/activity-filters"
        case .delete_all_trusted_organization:
            return "/organizations/my-trusted"
        case .delete_my_account:
            return "/users/delete-account"
        case .auto_sync:
            return "/users/auto-sync"
        case .shared_data_report:
            return "/organizations/download/shared-data-report"
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .key_exchange:
            return .post
        case .refresh_token:
            return .get
        case .login:
            return .post
        case .signup:
            return .post
        case .verify_otp:
            return .post
        case .resend_otp:
            return .post
        case .top_trusted_organization:
            return .get
        case .organization_profile:
            return .get
        case .my_trusted_organization:
            return .get
        case .delete_my_trusted_organization:
            return .delete
        case .share_data:
            return .post
        case .request_list:
            return .get
        case .force_update:
            return .post
        case .accept_reject_request:
            return .post
        case .blocked_organization_list:
            return .get
        case .block_unblock_organization:
            return .post
        case .read_notification:
            return .put
        case .activity_log_list:
            return .get
        case .activity_filters:
            return .get
        case .delete_all_trusted_organization:
            return .delete
        case .delete_my_account:
            return .delete
        case .auto_sync:
            return .post
        case .shared_data_report:
            return .get
        }
    }
}
