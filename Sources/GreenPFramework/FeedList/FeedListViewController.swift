//
//  FeedListViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit
import SnapKit
import UAdFramework
import GADNativeAdTemplate

class FeedListViewController : UIViewController {
    public let feedListViewModel = FeedListViewModel()
    private var detailViewModel = DetailViewModel()
    private var cellConfigs: [FeedCellConfig] = []
    
    var bannerDisplayFrequency: Int = 4
    
    var uAdNativeAd: UAdNativeAd?
    var uAdAdLoader: UAdAdLoader?
    
    var isRewardLoaded = false
    var reward: UAdRewardedAd!
    
    var bannerCount: Int = 0
    
    // for carousel
    let carouselScrollView = UIScrollView()
    let carouselPageControl = UIPageControl()
    var mainList: [MainData.Main] = []
    
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
        
        uAdAdLoader = UAdAdLoader(zoneId: "teirUpF0uHvCCIIi9vlbktdQpAwT", rootViewController: self, delegate: self)
        uAdAdLoader!.load()
        
        if(feedListViewModel.tabIndex == 0) {
            reward = UAdRewardedAd(zoneId: "NCSlLD5Jg74w0hdgCYrleWid4NLQ", rootViewController: self, delegate: self)
            reward?.load()
        }
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
        view.register(FeedListTableViewAdCell.self, forCellReuseIdentifier: FeedListTableViewAdCell.cellIdentifier)
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
            
//            self.tableView.tableFooterView = nil
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 65))
            self.tableView.tableFooterView = footerView
            
        }
        feedListViewModel.onShouldMoveDetailView = { feed in
            self.presentFeedDetailView(feed: feed)
        }
        feedListViewModel.onShouldMoveNewsDetailView = { feed in
            self.checkCanParticipateNewsDetailView(feed: feed)
        }
        feedListViewModel.onShouldDeleteCellConfig = { indexPath in
            self.deleteSelectedCell(at: indexPath)
        }
        
        detailViewModel.onSuccessReturnParticipateURL = { info in
            DispatchQueue.main.async {
                self.presentNewsFeedDetailView(info: info)
            }
        }
        detailViewModel.onFailureReturnParticipateURL = { message in
            DispatchQueue.main.async {
                self.alert(message: message, cancelTitle: "확인")
            }
        }
        detailViewModel.shouldDeleteRowOnFailureParticipate = {
            DispatchQueue.main.async {
                self.feedListViewModel.deleteRow()
            }
        }
        
        if(feedListViewModel.tabIndex == 0) {
            feedListViewModel.getMainList(completion: { list in
                self.mainList = list
                
                DispatchQueue.main.async {
                    if self.mainList.isEmpty {
                    } else {
                        self.setupScrollView()
                        self.setupPageControl()
                    }
                }
            })
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
        
        // for carousel
        if(feedListViewModel.tabIndex == 0) {
            stackView.addArrangedSubview(carouselScrollView)
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
                
//                self.tableView.tableFooterView = nil
                let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 65))
                self.tableView.tableFooterView = footerView
                
            } else {
                self.cellConfigs += feedCellConfigs
                self.bannerCount = self.cellConfigs.count / self.bannerDisplayFrequency
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadTableView(with feedCellConfigs: [FeedCellConfig]) {
        DispatchQueue.main.async {
            if feedCellConfigs.isEmpty {
                
//                self.tableView.tableFooterView = nil
                let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 65))
                self.tableView.tableFooterView = footerView
                
            } else {
                self.cellConfigs = feedCellConfigs
                self.bannerCount = self.cellConfigs.count / self.bannerDisplayFrequency
                self.tableView.reloadData()
            }
        }
    }
    
    private func presentFeedDetailView(feed: FeedList.Feed) {
        let vc = FeedDetailViewController()
        vc.detailViewModel = DetailViewModel(feed: feed)
        vc.delegate = self
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
            vc.delegate = self
            vc.isModalInPresentation = true
            let navi = NavigationController(rootViewController: vc)
            navi.presentationController?.delegate = vc
            self.present(navi, animated: true)
        }
    }
    
    private func deleteSelectedCell(at indexPath: IndexPath) {
        cellConfigs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func setupScrollView() {

        let imageViewWidth = view.frame.width - 20
        let imageViewHeight = imageViewWidth * 9.0 / 16.0
        
        carouselScrollView.delegate = self
        carouselScrollView.isPagingEnabled = true
        carouselScrollView.showsHorizontalScrollIndicator = false
        carouselScrollView.isDirectionalLockEnabled = true

        carouselScrollView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageViewHeight - 10)
            make.centerX.equalToSuperview()
        }
        
        for (index, _) in mainList.enumerated() {
            
            let bannerContainerView = UIView()
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true

            let xPos = CGFloat(index) * view.frame.width + 10
            let imageViewFrame = CGRect(x: xPos, y: 0, width: imageViewWidth, height: imageViewHeight - 10)
            imageView.frame = imageViewFrame
            imageView.kf.setImage(with: URL(string: mainList[index].iconURLStr))

            bannerContainerView.frame = imageViewFrame
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)

            imageView.tag = index
            
            bannerContainerView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.bottom.equalToSuperview()
            }
            
            if(mainList[index].id == "reward") {
                
                let iconImageView = UIImageView()
                iconImageView.backgroundColor = .yellow
                iconImageView.image = UIImage(named: "reward_point", in: Bundle.module, with: nil)
                iconImageView.contentMode = .scaleAspectFit
                
                let label = UILabel()
                label.text = "+시청하기"
                label.backgroundColor = .yellow
                label.textColor = UIColor.black
                label.font = UIFont.systemFont(ofSize: 12)
                
                let iconSize = CGSize(width: 30, height: 30)
                let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
                let totalWidth = iconSize.width + labelSize.width
                let iconXPos = imageViewFrame.width - totalWidth
                let iconYPos = imageViewFrame.height - iconSize.height
                
                iconImageView.frame = CGRect(x: iconXPos - 20, y: iconYPos - 20, width: iconSize.width, height: iconSize.height)
                label.frame = CGRect(x: iconXPos + iconSize.width - 20, y: iconYPos - 20, width: labelSize.width + 5, height: iconSize.height)
                
                bannerContainerView.addSubview(iconImageView)
                bannerContainerView.addSubview(label)
            }
            
            carouselScrollView.addSubview(bannerContainerView)
            
            bannerContainerView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(xPos)
                make.width.equalTo(imageViewWidth)
                make.height.equalTo(imageViewHeight - 10)
            }
        }
        
        carouselScrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(mainList.count), height: carouselScrollView.bounds.height)
    }

    func setupPageControl() {
        view.addSubview(carouselPageControl)

        carouselPageControl.numberOfPages = mainList.count
        carouselPageControl.currentPage = 0
        carouselPageControl.pageIndicatorTintColor = .gray
        carouselPageControl.currentPageIndicatorTintColor = .blue

        carouselPageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(carouselScrollView.snp.bottom).offset(-10)
        }
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        if let index = sender.view?.tag {
            let feed = feedListViewModel.mainDataConverter(data: mainList[index])
            
            if(feed.id == "reward") {
                if(isRewardLoaded) {
                    reward.show()
                }
            } else {
                self.presentFeedDetailView(feed: feed)
            }
        }
    }
}

extension FeedListViewController : TagViewControllerDelegate {
    func tagViewDidSelectItemOn(tagKey key: String) {
        feedListViewModel.changeTag(key: key)
        
        if(key == "0") {
            carouselScrollView.isHidden = false
        } else {
            carouselScrollView.isHidden = true
        }
    }
}

extension FeedListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(cellConfigs.count > 0) {
            return cellConfigs.count + bannerCount
        } else {
            return cellConfigs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = FeedListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
//        cell.configure(cellConfigs[indexPath.row])
//        return cell

        if(AdsGlobal.shared.isNativeLoaded) {
            
            let itemIdx = indexPath.row + 1
            if itemIdx % bannerDisplayFrequency == 0 && indexPath.row != 0 {
                
                let bannerIdx = nextBannerIndex()
                let cell = FeedListTableViewAdCell.dequeueReusableCell(in: tableView, for: indexPath)
                cell.configure(AdsGlobal.shared.nativeAds[bannerIdx])
                cell.tag = -1
                
                AdsGlobal.shared.exposureCnt[bannerIdx] += 1
                resetFreq(itemIdx: itemIdx)
                return cell
            } else {
                
                let sub: Int = itemIdx / bannerDisplayFrequency
                let idx = indexPath.row - sub
                
                let cell = FeedListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
                cell.configure(cellConfigs[idx])
                cell.tag = idx
                
                resetFreq(itemIdx: itemIdx)
                return cell
            }
            
        } else {
            
            let cell = FeedListTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
            cell.configure(cellConfigs[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(AdsGlobal.shared.isNativeLoaded && bannerCount > 0) {
            if let cell = tableView.cellForRow(at: indexPath) {
                let idx = cell.tag
                if(idx >= 0) {
                    feedListViewModel.selectRow(at: indexPath, idx: idx)
                }
            }
        } else {
            feedListViewModel.selectRow(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func resetFreq(itemIdx: Int) {
        if(itemIdx <= 62) {
            bannerDisplayFrequency = 5
        } else if(itemIdx > 62 && itemIdx <= 125) {
            bannerDisplayFrequency = 6
        } else {
            bannerDisplayFrequency = 7
        }
    }
    
    func nextBannerIndex() -> Int {
        var minIdx = 0
        var minCnt = Int.max
        
        for (index, count) in AdsGlobal.shared.exposureCnt.enumerated() {
            if count < minCnt {
                minIdx = index
                minCnt = count
            }
        }
        
        let minExposureBanners = AdsGlobal.shared.exposureCnt.filter { $0 == minCnt }
        if minExposureBanners.count == AdsGlobal.shared.nativeAds.count {
            return Int.random(in: 0..<AdsGlobal.shared.nativeAds.count)
        } else {
            return minIdx
        }
    }
}

extension FeedListViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView == carouselScrollView) {
            let pageIndex = Int(round(scrollView.contentOffset.x / view.bounds.width))
            carouselPageControl.currentPage = pageIndex
        } else {
            let position = scrollView.contentOffset.y
                
            if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
                self.tableView.tableFooterView = createSpinnerFooter()
                feedListViewModel.loadNextPage()
            }
        }
    }
}

extension FeedListViewController : FeedDetailViewControllerDelegate {
    func feedDetailViewDidReceiveFailMessage() {
        feedListViewModel.deleteRow()
    }
}

extension FeedListViewController : TimerWebViewControllerDelegate {
    func timerWebViewDidCompleteAddJoin() {
        feedListViewModel.deleteRow()
    }
}


extension FeedListViewController: UAdNativeAdLoaderDelegate {
    
    func onNativeLoaderLoaded(nativeAd: UAdFramework.UAdNativeAd) {
        if(uAdNativeAd == nil) {
            uAdNativeAd = nativeAd
        }
    }
    
    func onNativeLoaderFailed(msg: String) {
    }
}

extension FeedListViewController: UAdNativeAdDelegate {
    func onNativeAdLoaded() {
    }
    func onNativeAdClicked() {
    }
    func onNativeAdShow() {
    }
    func onNativeAdDismiss() {
    }
    func onNativeAdFailed(msg: String) {
    }
}

extension FeedListViewController: UAdFullScreenDelegate {
    func onFullScreenLoaded() {
        isRewardLoaded = true
    }
    
    func onFullScreenClicked() {
    }
    
    func onFullScreenShow() {
    }
    
    func onFullScreenDismiss() {
    }
    
    func onFullScreenFailed(msg: String) {
        print("onFullScreenFailed : \(msg)")
    }
}
