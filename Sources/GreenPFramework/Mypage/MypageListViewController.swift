//
//  MypageListViewController.swift
//
//
//  Created by 신아람 on 12/22/23.
//

import UIKit
import SnapKit

class MypageListViewController : UIViewController {
    
    public let feedListViewModel = ParticipateViewModel()
    private var cellConfigs: [MypageCellConfig] = []
    
    private var typeIdx = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("Never Will Happen")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(index: Int) {
        self.init()
        feedListViewModel.setIndex(typeIndex: index)
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .clear
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 70
        view.register(MypageListTableViewBottomCell.self, forCellReuseIdentifier: "cell")
        view.register(MypageListTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: "header")
        view.delegate = self
        view.dataSource = self
        
        if #available(iOS 15, *) {
            view.sectionHeaderTopPadding = 0
        }
        
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
        feedListViewModel.onSuccessLoadParticipateList = { configs in
            self.updateTableView(with: configs)
        }
        feedListViewModel.onNeedReloadParticipateList = { configs in
            self.reloadTableView(with: configs)
        }
        feedListViewModel.onFailLoadParticipateNoMorePage = {
            self.tableView.tableFooterView = nil
        }
    }
    
    /// Initialize constraints
    private func setupLayoutConstraints() {
        let bgView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
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
    
    private func updateTableView(with feedCellConfigs: [MypageCellConfig]) {
        DispatchQueue.main.async {
            if feedCellConfigs.isEmpty {
                self.tableView.tableFooterView = nil
            } else {
                self.cellConfigs += feedCellConfigs
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadTableView(with feedCellConfigs: [MypageCellConfig]) {
        DispatchQueue.main.async {
            if feedCellConfigs.isEmpty {
                self.tableView.tableFooterView = nil
            } else {
                self.cellConfigs = feedCellConfigs
                self.tableView.reloadData()
            }
        }
    }
    
    private func deleteSelectedCell(at indexPath: IndexPath) {
        cellConfigs.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension MypageListViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return cellConfigs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(cellConfigs[section].isParticipateList) {
            return 0
        } else {
            return cellConfigs[section].isHidden ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MypageListTableViewBottomCell
        cell.configure(cellConfigs[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? MypageListTableViewHeaderCell
        cell?.configure(cellConfigs[section])
        
        if(!cellConfigs[section].isParticipateList) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(sender:)))
            cell?.addGestureRecognizer(tapGesture)
            
            cell?.tag = section
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(cellConfigs[indexPath.section].isParticipateList) {
            return 0.0
        } else {
            if cellConfigs[indexPath.section].isHidden {
                return 0.0 // 숨겨진 행의 경우 높이를 0으로 설정
            } else {
                // 원하는 높이 또는 다른 동적인 계산 방법을 여기에 추가
                let cellWidth = tableView.frame.width - 40 // 좌우 여백이 각각 20
                let label = UILabel()
                label.font = .nanumSquare(size: 13, family: .light)
                label.numberOfLines = 0
                label.text = cellConfigs[indexPath.section].content

                let labelSize = label.sizeThatFits(CGSize(width: cellWidth, height: CGFloat.greatestFiniteMagnitude))
                return labelSize.height
            }
        }
    }
    
    @objc func headerTapped(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        cellConfigs[section].isHidden.toggle()
        
        let cell = sender.view as! MypageListTableViewHeaderCell
        cell.setOpened(opened: cellConfigs[section].isHidden)
        
        tableView.beginUpdates()
        
        let indexPaths = [IndexPath(row: 0, section: section)]
        
        if (cellConfigs[section].isHidden) {
            tableView.deleteRows(at: indexPaths, with: .none)
        } else {
            tableView.insertRows(at: indexPaths, with: .none)
        }
        
        tableView.endUpdates()
    }
}

extension MypageListViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
            
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            self.tableView.tableFooterView = createSpinnerFooter()
            feedListViewModel.loadNextPage()
        }
    }
}

