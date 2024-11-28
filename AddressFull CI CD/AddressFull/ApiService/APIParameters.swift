//
//  APIParameters.swift
//  AddressFull
//
//  Created by MacBook Pro  on 20/11/23.
//

import Foundation
import CoreLocation


struct APIParameters {
    
    // MY TRUSTED ORGANIZATION
    static func myTrustedOrganization(search: String,
                                      page: Int,
                                      page_size: Int = 10,
                                      timezone: String) -> [String : Any] {
        if search.count > 0 {
            return [ApiHeaderAndParameters.search : search,
                    ApiHeaderAndParameters.timezone : "\(timezone)",
                    ApiHeaderAndParameters.page : "\(page)",
                    ApiHeaderAndParameters.page_size : page_size]
        } else {
            return [ApiHeaderAndParameters.timezone : "\(timezone)",
                    ApiHeaderAndParameters.page : "\(page)",
                    ApiHeaderAndParameters.page_size : page_size]
        }
    }
    
    // BLOCKED ORGANIZATION
    static func blockedOrganization(search: String,
                                    timezone: String,
                                    page: Int,
                                    page_size: Int = 10) -> [String : Any] {
        if search.count > 0 {
            return [ApiHeaderAndParameters.search : search,
                    ApiHeaderAndParameters.page : "\(page)",
                    ApiHeaderAndParameters.timezone : "\(timezone)",
                    ApiHeaderAndParameters.page_size : page_size]
        } else {
            return [ApiHeaderAndParameters.page : "\(page)",
                    ApiHeaderAndParameters.timezone : "\(timezone)",
                    ApiHeaderAndParameters.page_size : page_size]
        }
    }
    
    
    // TOP TRUSTED ORGANIZATION
    static func topTrustedOrganization(search: String,
                                       page: Int) -> [String : Any] {        
        if search.count > 0 {
            return [
                ApiHeaderAndParameters.search : search,
                ApiHeaderAndParameters.page : "\(page)"
            ]
        } else {
            return [
                ApiHeaderAndParameters.page : "\(page)",
            ]
        }
    }
    
    
    // ORGANIZATION PROFILE
    static func organizationProfile(timezone: String) -> [String : Any] {
        return [ApiHeaderAndParameters.timezone : "\(timezone)"]
    }
    
    
    // DELETE ORGANIZATION
    static func deleteOrganization(id: String) -> [String : Any] {
        return [ApiHeaderAndParameters.id : id]
    }
    
    
    // REQUEST
    static func requestList(page: Int,
                            timezone: String,
                            request_period: Int) -> [String : Any] {
        
        return [ApiHeaderAndParameters.page : "\(page)",
                ApiHeaderAndParameters.req_period : request_period,
                ApiHeaderAndParameters.timezone : "\(timezone)",
                ApiHeaderAndParameters.is_read : 0]
    }
    
    
    // NOTIFICATION
    static func readNotification(id: String) -> [String : Any] {
        return [ApiHeaderAndParameters.id : id]
    }
    
    
    // ACTIVITY LOG
    static func activityList(book_mark: String?,
                             timezone: String,
                             start_date: String,
                             end_date: String,
                             sort_order: String) -> [String : Any] {
        
        if book_mark != nil {
            return [ApiHeaderAndParameters.bookmark : book_mark ?? "",
                    ApiHeaderAndParameters.timezone : "\(timezone)",
                    ApiHeaderAndParameters.start_date : "\(start_date)",
                    ApiHeaderAndParameters.end_date : "\(end_date)",
                    ApiHeaderAndParameters.sort_order : "\(sort_order)"
            ]
        } else {
            return [ApiHeaderAndParameters.timezone : "\(timezone)",
                    ApiHeaderAndParameters.start_date : "\(start_date)",
                    ApiHeaderAndParameters.end_date : "\(end_date)",
                    ApiHeaderAndParameters.sort_order : "\(sort_order)"
            ]
        }
    }
    
    
    // DELETE ACCOUNT
    static func deleteAccountOrTrustedOrganizations() -> [String : Any] {
        return [ApiHeaderAndParameters.type : "yes"]
    }
}

