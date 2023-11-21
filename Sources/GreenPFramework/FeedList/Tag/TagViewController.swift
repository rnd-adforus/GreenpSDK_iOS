//
//  TagViewController.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

protocol TagViewControllerDelegate : NSObject {
    func tagViewDidSelectItemOn(tagKey key: String)
}

/// 태그 뷰 컨트롤러
class TagViewController : UIViewController {
    private var alignment: NSTextAlignment = .left
    private var delegate: TagViewControllerDelegate?
    
    public var tags: [TagCellConfig] = [] {
        didSet {
            cellConfigs = tags
            collectionView.reloadData()
        }
    }
    private var cellConfigs: [TagCellConfig] = []
    private var selectedIndex: Int = 0

    // MARK: Object lifecycle

    convenience init(delegate: TagViewControllerDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    // MARK: Setup UI properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isScrollEnabled = true
        view.backgroundColor = .clear
        view.register(TagCell.self, forCellWithReuseIdentifier: TagCell.cellIdentifier)
        view.showsHorizontalScrollIndicator = false
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
        collectionView.reloadData()
    }
    
    // MARK: Main

    /// Initialize constraints
    private func setupLayoutConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    /// Initialize properties
    private func initView() {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// Initialize actions
    private func setupActions() {
    }
}

// MARK: CollectionView Delegate & DataSource

extension TagViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellConfigs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TagCell.dequeueReusableCell(in: collectionView, for: indexPath)
        cell.configure(cellConfigs[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellConfigs[selectedIndex].isSelected = false
        cellConfigs[indexPath.row].isSelected = true
        collectionView.reloadItems(at: [indexPath, IndexPath(row: selectedIndex, section: 0)])
        selectedIndex = indexPath.row
        delegate?.tagViewDidSelectItemOn(tagKey: cellConfigs[indexPath.row].key)
    }
}

extension TagViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = TagCell.dequeueReusableCell(in: collectionView, for: indexPath)
        let cellSize = cell.sizeFittingWith(cellHeight: collectionView.frame.size.height - 20, text: cellConfigs[indexPath.row].tag)
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 10, right: 5)
    }
}
