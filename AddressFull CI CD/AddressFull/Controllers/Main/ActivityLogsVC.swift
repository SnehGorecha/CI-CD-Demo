//
//  ActivityLogsVC.swift
//  AddressFull
//
//  Created by MacBook Pro  on 08/11/23.
//

import UIKit

class ActivityLogsVC: BaseViewController {
    
    // MARK: - OBJECTS & OUTLETS
    
    let activity_view_model = ActivityLogViewModel()
    var current_bookmark : String?
    var fetched_records_count = 0
    var pull_to_refresh_started = false
    var selected_filter_model : ActivityFilterDataModel?
    var arr_filters = [ActivityFilterDataModel]()
    let date_formatter = DateFormatter()
    
    @IBOutlet weak var dropdown_filter: BaseIOSDropDown!
    @IBOutlet weak var view_seperator: UIView!
    @IBOutlet weak var view_segment: UIView!
    @IBOutlet weak var view_filter: UIView!
    @IBOutlet weak var navigation_bar: UIView!
    @IBOutlet weak var tbl_view_activity_logs_list: NotificationTblView!
    @IBOutlet weak var segment_activity_logs: BaseSegmentControl!
    
    
    // MARK: - VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_activity_logs_list.refresh_control.beginRefreshing()
                self.tbl_view_activity_logs_list.setContentOffset(CGPointMake(0, -self.tbl_view_activity_logs_list.refresh_control.bounds.size.height), animated: false)
                self.tbl_view_activity_logs_list.isScrollEnabled = false
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigation_bar.navigationBarSetup(title: LocalText.Menu().activity_log(),
                                               isWithBackOption: false,{
            self.navigateTo(.profile_vc(is_from_login: false))
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            if self.pull_to_refresh_started {
                self.tbl_view_activity_logs_list.refresh_control.endRefreshing()
                self.tbl_view_activity_logs_list.setContentOffset(.zero, animated: false)
            }
        }
    }
    
    override func refreshViaDataSyncNotification(_ notification: NSNotification) {
        DispatchQueue.main.async {
            self.navigation_bar.navigationBarSetup(title: LocalText.Menu().activity_log(),
                                                   isWithBackOption: false,{
                self.navigateTo(.profile_vc(is_from_login: false))
            })
        }
    }
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    func setupUI() {
        self.initialSetup()
        self.localTextSetup()
        self.getActivityLogList()
        self.setupFilter()
    }
    
    func localTextSetup() {
        self.segment_activity_logs.setTitle(LocalText.Request().recent(), forSegmentAt: 0)
        self.segment_activity_logs.setTitle(LocalText.Request().previous(), forSegmentAt: 1)
    }
    
    func setupFilter() {
        self.view_filter.setupLayer(cornerRadius: 14)
        self.view_seperator.backgroundColor = AppColor.primary_gray()
        
        self.dropdown_filter.clearsOnBeginEditing = false
        self.dropdown_filter.checkMarkEnabled = false
        self.dropdown_filter.selectedRowColor = .white
        self.dropdown_filter.isSearchEnable = false
        
        self.dropdown_filter.textColor = .black
        self.dropdown_filter.placeholder = LocalText.Request().filter()
        
        self.dropdown_filter.didSelect { (selectedText,index,id) in
            
            self.dropdown_filter.text = selectedText
            
            if index < self.arr_filters.count {
                self.selected_filter_model = self.arr_filters[index]
                self.getActivityLogList()
            }
        }
        
        self.view_segment.setupLayer(cornerRadius: self.segment_activity_logs.layer.cornerRadius)
    }
    
    func initialSetup() {
        self.view_filter.isHidden = true
        
        self.date_formatter.dateFormat = "yyyy-MM-dd"
        
        self.selected_filter_model = ActivityFilterDataModel(start_date: date_formatter.string(from: Date()), end_date: date_formatter.string(from: Date()))
    }
    
    
    // MARK: - TABLE VIEW SET UP
    
    func tblViewActivityLogSetup() {
        
        self.tbl_view_activity_logs_list.addPullRefresh()
        
        self.tbl_view_activity_logs_list.pull_to_refresh_block = {
            self.current_bookmark = nil
            self.getActivityLogList(is_pull_to_refresh: true)
            self.pull_to_refresh_started = true
        }
        
        self.tbl_view_activity_logs_list.pagination_block =  {
            if self.fetched_records_count > 0 {
                self.tbl_view_activity_logs_list.showLoadingIndicatorInFooter()
                self.getActivityLogList(is_pull_to_refresh: false)
            }
        }
        
        DispatchQueue.main.async {
            self.tbl_view_activity_logs_list.reloadData()
        }
    }
    
    
    // MARK: - API CALL
    
    func getActivityLogList(is_pull_to_refresh : Bool? = nil) {
        
        self.tbl_view_activity_logs_list.hideProgressBar()
        
        self.tbl_view_activity_logs_list.isScrollEnabled = !(is_pull_to_refresh ?? false)
        
        self.activity_view_model.getActivityLogListApiCall(book_mark: self.current_bookmark,
                                                           start_date: self.selected_filter_model?.start_date ?? "",
                                                           end_date: self.selected_filter_model?.end_date ?? "",
                                                           sort_order: ApiHeaderAndParameters.desc,
                                                           view_for_progress_indicator: self.tbl_view_activity_logs_list,
                                                           is_pull_to_refresh: is_pull_to_refresh != nil)
        { is_success, model  in
            
            
            if is_success , self.tbl_view_activity_logs_list.notification_list.count > 0 || model?.data?.fetched_records_count ?? 0 > 0 {
                
                if self.current_bookmark == nil {
                    self.tbl_view_activity_logs_list.notification_list = model?.data?.results ?? []
                } else {
                    self.tbl_view_activity_logs_list.notification_list.append(contentsOf: model?.data?.results ?? [])
                }
                
                self.current_bookmark = model?.data?.bookmark
                self.fetched_records_count = model?.data?.fetched_records_count ?? 0
                self.tbl_view_activity_logs_list.hideNoDataLabel()
                
            } else {
                self.tbl_view_activity_logs_list.showNoDataLabel()
                self.tbl_view_activity_logs_list.notification_list = []
            }
            
            self.tblViewActivityLogSetup()
            self.tbl_view_activity_logs_list.hideLoadingIndicatorInFooter()
            self.tbl_view_activity_logs_list.hidePullToRefresh()
            self.tbl_view_activity_logs_list.isScrollEnabled = true
            self.pull_to_refresh_started = false
            
        }
    }
    
    
    func getFilterList(completion: (@escaping() -> Void)) {
        
        self.activity_view_model.getFilterListApiCall(view_for_progress_indicator: self.tbl_view_activity_logs_list,
                                                      completionHandler:
        { is_success, model in
            
            self.dropdown_filter.optionArray = []
            
            if is_success , model?.data?.count ?? 0 > 0 {
                
                model?.data?.forEach({ data_model in
                    if let title = data_model.title {
                        self.dropdown_filter.optionArray.append(title)
                        self.arr_filters.append(data_model)
                    }
                })
                
                if let default_title = model?.data?.first?.title {
                    self.dropdown_filter.text = default_title
                }
                
                if let date_model = model?.data?.first {
                    self.selected_filter_model = ActivityFilterDataModel(title: date_model.title, start_date: date_model.start_date, end_date: date_model.end_date)
                }
                
            }
            
            completion()
        })
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func segment_activity_logs_changed(_ sender: BaseSegmentControl) {
                
        AlamofireAPICallManager().disconnectAllApi()
        
        DispatchQueue.main.async {
            self.view_filter.isHidden = sender.selectedSegmentIndex == 0
            self.tbl_view_activity_logs_list.notification_list = []
        }
        
        if sender.selectedSegmentIndex == 0 {
            
            self.selected_filter_model = ActivityFilterDataModel(start_date: self.date_formatter.string(from: Date()), end_date: self.date_formatter.string(from: Date()))
            self.current_bookmark = nil
            self.getActivityLogList()
            
        } else {
            
            self.current_bookmark = nil
            self.getFilterList {
                self.getActivityLogList()
            }
        }
        
    }
    
}
