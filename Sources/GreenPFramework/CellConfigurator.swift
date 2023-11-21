//
//  CellConfigurator.swift
//  GreenPFramework
//
//  Created by 심현지 on 2023/11/14.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

protocol CellConfigurator {
    static var reuseID: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType> : CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    static var reuseID: String { return String(describing: CellType.self) }

    var item: DataType
    
    init(item: DataType) {
        self.item = item
    }
    
    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType> : CellConfigurator where CellType.DataType == DataType, CellType: UICollectionViewCell {
    static var reuseID: String { return String(describing: CellType.self) }
    
    let item: DataType
    
    init(item: DataType) {
        self.item = item
    }

    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item)
    }
}

/// cell configurator를 사용하는 뷰 모델의 프로토콜
protocol CellConfiguratorProtocol {
    func itemCount(in section: Int) -> Int
    func cell(tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}


/**
 Cell Reusable Protocol & Extension
 */
/// Collection View Cell protocol
protocol CollectionViewCellReusable {
    associatedtype CellType : UICollectionViewCell = Self
    
    /// reuse identifier
    static var cellIdentifier : String { get }
    
    /// Cell 재사용 호출 함수
    static func dequeueReusableCell(in collectionView : UICollectionView, for indexPath: IndexPath) -> CellType
}

extension CollectionViewCellReusable where Self : UICollectionViewCell {
    static var cellIdentifier : String {
        return String(describing: Self.self)
    }

    static func dequeueReusableCell(in collectionView : UICollectionView, for indexPath: IndexPath) -> CellType {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CellType
    }
}


/// Table View Cell protocol
protocol TableViewCellReusable {
    associatedtype CellType : UITableViewCell = Self
    
    /// reuse identifier
    static var cellIdentifier : String { get }
    
    /// Cell 재사용 호출 함수
    static func dequeueReusableCell(in tableView : UITableView, for indexPath: IndexPath) -> CellType
}

extension TableViewCellReusable where Self : UITableViewCell {
    
    static var cellIdentifier : String {
        return String(describing: Self.self)
    }
    
    static var nib : UINib {
        return UINib(nibName: String(describing: Self.self), bundle: nil)
    }

    static func dequeueReusableCell(in tableView : UITableView, for indexPath: IndexPath) -> CellType {
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CellType
    }
}

