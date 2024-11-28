//
//  RequestVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 02/11/23.
//

import UIKit

class RequestVC: BaseViewController {
    
    
    // MARK: - OBEJCTS & OUTLETS
    
    let request_list_view_model = RequestListViewModel()
    var current_page = 1
    var request_period = 0
    var total_pages = 1
    var request_list = [RequestListResponseModel]()
    var pull_to_refresh_started = false
    
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var segment_view_request: BaseSegmentControl!
    @IBOutlet weak var tbl_view_view_request: RequestTblView!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_view_request.refresh_control.beginRefreshing()
                self.tbl_view_view_request.setContentOffset(CGPointMake(0, -self.tbl_view_view_request.refresh_control.bounds.size.height), animated: false)
                self.tbl_view_view_request.isScrollEnabled = false
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Home().requests(),
                                               isWithBackOption: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_view_request.refresh_control.endRefreshing()
                self.tbl_view_view_request.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.localTextSetup()
        self.getRequestList()
    }
    
    func localTextSetup() {
        self.segment_view_request.setTitle(LocalText.Request().recent(), forSegmentAt: 0)
        self.segment_view_request.setTitle(LocalText.Request().previous(), forSegmentAt: 1)
    }
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewRequestListDataSetup() {
        
        self.tbl_view_view_request.addPullRefresh()
        
        self.tbl_view_view_request.pull_to_refresh_block = {
            self.current_page = 1
            self.getRequestList(is_pull_to_refresh: true)
            self.pull_to_refresh_started = true
        }
        
        self.tbl_view_view_request.pagination_block =  {
            if self.current_page < self.total_pages {
                self.tbl_view_view_request.showLoadingIndicatorInFooter()
                self.current_page += 1
                self.getRequestList(is_pull_to_refresh: false)
            }
        }
        
        self.tbl_view_view_request.button_accept_pressed_block = { request_index in
            self.acceptRejectRequest(index: request_index, accept: true)
        }
        
        self.tbl_view_view_request.button_reject_pressed_block = { request_index in
            
            self.showPopupAlert(title: Message.are_you_sure_you_want_to_reject_the_request(),
                                message: nil,
                                leftTitle: LocalText.AlertButton().yes(),
                                rightTitle: LocalText.AlertButton().no(),
                                didPressedLeftButton: {
                self.dismiss(animated: true)
                self.acceptRejectRequest(index: request_index, accept: false)
            },
                                didPressedRightButton: nil)
        }
        
        DispatchQueue.main.async {
            self.tbl_view_view_request.reloadData()
        }
    }
    
    
    // MARK: - API CALL
    
    func getRequestList(is_pull_to_refresh : Bool? = nil,completion: (() -> Void)? = nil) {
        
        self.tbl_view_view_request.isScrollEnabled = !(is_pull_to_refresh ?? false)
        
        self.request_list_view_model.getRequestListApiCall(request_period: self.request_period,
                                                           currentPage: self.current_page,
                                                           view_for_progress_indicator: self.tbl_view_view_request,
                                                           is_pull_to_refresh: is_pull_to_refresh != nil)
        { is_success, model  in
            
            if is_success, let list = model?.data?.notification_list , list.count > 0 {
                
                self.tbl_view_view_request.hideNoDataLabel()
                self.request_list = list
                self.total_pages = model?.data?.page_info?.total_pages ?? 1
                
                if self.current_page == 1 {
                    self.tbl_view_view_request.request_list = list
                } else {
                    self.tbl_view_view_request.request_list.append(contentsOf: list)
                }
            } else {
                
                self.tbl_view_view_request.showNoDataLabel()
                self.tbl_view_view_request.request_list = []
            }
            
            self.tblViewRequestListDataSetup()
            self.tbl_view_view_request.hideLoadingIndicatorInFooter()
            self.tbl_view_view_request.hidePullToRefresh()
            self.tbl_view_view_request.isScrollEnabled = true
            self.pull_to_refresh_started = false
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    func acceptRejectRequest(index: Int,accept: Bool) {
        
        let request_model = AcceptRejectRequestModel(request_id: self.request_list[index].request_id ?? "", organization_id: self.request_list[index].organization_id ?? "", request_status: accept)
        
        self.request_list_view_model.acceptRejectRequestApiCall(
            accept_reject_request_model: request_model,
            view_for_progress_indicator: self.tbl_view_view_request)
        { is_success, model  in
            
            if is_success {
                
                self.getRequestList()
                
                if accept, let id = self.request_list[index].organization_id {
                    self.navigateTo(.organization_profile(id: id))
                }
                
                NotificationCenter.default.post(name: Notification.Name(NotificationName.reload_home_vc), object: nil, userInfo: nil)
            }
        }
    }
    
    // MARK: - SEGMENT ACTIONS
    
    @IBAction func segment_view_request_changed(_ sender: BaseSegmentControl) {
        AlamofireAPICallManager().disconnectAllApi()
        self.request_period = sender.selectedSegmentIndex
        self.current_page = 1
        self.getRequestList()
    }
}
