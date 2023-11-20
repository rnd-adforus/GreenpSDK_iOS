//
//  FeedListViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit

class FeedListViewController : UIViewController {
    public let feedListViewModel = FeedListViewModel()
    private var detailViewModel = DetailViewModel()
    private var cellConfigs: [FeedCellConfig] = []
    
    // MARK: Object lifecycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(index: Int) {
        self.init()
        feedListViewModel.tabIndex = index
    }
    
    // MARK: Setup UI properties
    
    private lazy var tagViewController: TagViewController = {
        let vc = TagViewController(delegate: self)
        addChild(vc)
        return vc
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 70
        view.register(FeedListTableViewCell.self, forCellReuseIdentifier: FeedListTableViewCell.cellIdentifier)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    // MARK: View lifecycle
    
    override func loadView() {
        super.loadView()
        setupLayoutConstraints()
        initView()
        setupActions()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedListViewModel.onSuccessLoadCategories = { tags in
            self.updateTags(tags)
        }
        feedListViewModel.onSuccessLoadFeedList = { configs in
            self.updateTableView(with: configs)
        }
        feedListViewModel.onNeedReloadFeedList = { configs in
            self.reloadTableView(with: configs)
        }
        feedListViewModel.onFailLoadFeedNoMorePage = {
            self.tableView.tableFooterView = nil
        }
        feedListViewModel.onShouldMoveDetailView = { feed in
            self.presentFeedDetailView(feed: feed)
        }
        feedListViewModel.onShouldMoveNewsDetailView = { feed in
            self.checkCanParticipateNewsDetailView(feed: feed)
        }
        detailViewModel.onSuccessReturnParticipateURL = { info in
            self.presentNewsFeedDetailView(info: info)
        }
        detailViewModel.onFailureReturnParticipateURL = { message in
            DispatchQueue.main.async {
                self.alert(message: message, cancelTitle: "확인")
            }
        }
    }
    
    /// Initialize constraints
    private func setupLayoutConstraints() {
        let bgView: UIView = {
            let view = UIView()
            view.backgroundColor = .RGB(225)
            return view
        }()
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            return stackView
        }()
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.addArrangedSubview(tagViewController.view)
        tagViewController.view.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        stackView.addArrangedSubview(tableView)
    }
    
    /// Initialize properties
    private func initView() {
        view.backgroundColor = .clear
    }
    
    /// Initialize actions
    private func setupActions() {
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    private func updateTags(_ tags: [SettingsData.Data.Tab.Filter]) {
        DispatchQueue.main.async {
            if tags.isEmpty {
                self.tagViewController.view.isHidden = true
            } else {
                let config = TagCellConfig(tag: "#전체", key: "0", isSelected: true)
                let configs = tags.map{ TagCellConfig(tag: $0.name, key: $0.key) }
                self.tagViewController.tags = [config] + configs
            }
        }
    }
    
    private func updateTableView(with feedCellConfigs: [FeedCellConfig]) {
        DispatchQueue.main.async {
            if feedCellConfigs.isEmpty {
                self.tableView.tableFooterView = nil
            } else {
                self.cellConfigs += feedCellConfigs
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadTableView(with feedCellConfigs: [FeedCellConfig]) {
        DispatchQueue.main.async {
            if feedCellConfigs.isEmpty {
                self.tableView.tableFooterView = nil
            } else {
                self.cellConfigs = feedCellConfigs
                self.tableView.reloadData()
            }
        }
    }
    
    private func presentFeedDetailView(feed: FeedList.Feed) {
        let vc = FeedDetailViewController()
        vc.detailViewModel = DetailViewModel(feed: feed)
        let navi = NavigationController(rootViewController: vc)
        present(navi, animated: true)
    }
    
    private func checkCanParticipateNewsDetailView(feed: FeedList.Feed) {
        detailViewModel.feed = feed
    }
    
    private func presentNewsFeedDetailView(info: ParticipateInfo) {
        DispatchQueue.main.async {
            let vc = TimerWebViewController(url: info.url)
            vc.timerWebViewModel = TimerWebViewModel(info: info)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func presentDetailWebView(url: String) {
        DispatchQueue.main.async {
            let vc = WebViewController(url: url)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension FeedListViewController : TagViewControllerDelegate {
    func tagViewDidSelectItemOn(tagKey key: String) {
//        cellConfigs.removeAll()
        feedListViewModel.changeTag(key: key)
    }
}

extension FeedListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellConfigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FeedListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        cell.configure(cellConfigs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        feedListViewModel.selectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}

extension FeedListViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
            
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            self.tableView.tableFooterView = createSpinnerFooter()
            feedListViewModel.loadNextPage()
        }
    }
}
