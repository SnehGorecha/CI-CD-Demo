//
//  CustomTableView.swift
//  AddressFull
//
//  Created by Sneh on 11/01/24.
//

import Foundation
import UIKit


/// This is custom table view class with pagination and pull to refresh.
class CustomTableView : UITableView {
    
    // MARK: - OBJECTS
    
    /// Label for empty data.
    private var no_data_label = UILabel()
    
    /// Label for empty data.
    var is_pagination_called = false
    
    /// Use this block to get call back for pagination.
    var pagination_block : (() -> Void)?
    
    /// Use this block to get call back for pull to refresh.
    var pull_to_refresh_block : (() -> Void)?
    
    /// Refresh control for table view.
    var refresh_control = UIRefreshControl()
    
    
    // MARK: - CUSTOM FUNCTIONS
    
    /// Use this function to add pull to refresh in table view.
    func addPullRefresh() {
        DispatchQueue.main.async {
            self.refresh_control.addTarget(self, action: #selector(self.pullToRefreshCalled), for: .valueChanged)
            self.addSubview(self.refresh_control)
        }
    }
    
    @objc private func pullToRefreshCalled() {
        if let pull_to_refresh_block = self.pull_to_refresh_block {
            pull_to_refresh_block()
        }
    }
    
    /// Use this function to hide pull to refresh in table view.
    func hidePullToRefresh() {
        DispatchQueue.main.async {
            self.refresh_control.endRefreshing()
        }
    }
    
    /// Use this function to add empty data label in table view.
    func addNoDataLabel() {
        DispatchQueue.main.async {
            self.no_data_label = UILabel(frame: self.bounds)
            self.no_data_label.textAlignment = .center
            self.addSubview(self.no_data_label)
            self.hideNoDataLabel()
        }
    }
    
    /// Use this function to show empty data label in table view.
    func showNoDataLabel(is_for_search: Bool = false) {
        DispatchQueue.main.async {
            self.no_data_label.textColor = is_for_search ? AppColor.primary_green() : .gray
            self.no_data_label.text = is_for_search ? Message.no_match_found() : Message.no_data_found()
            self.no_data_label.isHidden = false
        }
    }
    
    /// Use this function to hide empty data label in table view.
    func hideNoDataLabel() {
        DispatchQueue.main.async {
            self.no_data_label.isHidden = true
        }
    }
    
    /// Use this function to show loading indicator in table footer view.
    func showLoadingIndicatorInFooter() {
        let loading_indicator_view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let loading_indicator = UIActivityIndicatorView(style: .large)
        loading_indicator.center = loading_indicator_view.center
        loading_indicator.translatesAutoresizingMaskIntoConstraints = true
        loading_indicator.startAnimating()
        DispatchQueue.main.async {
            loading_indicator_view.addSubview(loading_indicator)
            self.tableFooterView = loading_indicator_view
        }
    }
    
    /// Use this function to hide loading indicator in table footer view.
    func hideLoadingIndicatorInFooter() {
        DispatchQueue.main.async {
            self.tableFooterView = nil
            self.is_pagination_called = false
        }
    }
}


// MARK: - EXTENSION SCROLL VIEW
extension CustomTableView : UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y - 70
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        let isDraggingForRefresh = scrollView.isDragging && offsetY <= 0
        
        if !is_pagination_called, !isDraggingForRefresh, offsetY > contentHeight - screenHeight, contentHeight > screenHeight {
            if let paginationBlock = self.pagination_block {
                paginationBlock()
                self.is_pagination_called = true
            }
        }
    }
}
