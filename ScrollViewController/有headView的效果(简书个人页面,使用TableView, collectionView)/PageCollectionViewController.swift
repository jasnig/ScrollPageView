//
//  PageCollectionViewController.swift
//  ScrollViewController
//
//  Created by ZeroJ on 16/8/31.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class PageCollectionViewController: PageViewController {
    static let cellID = "cellID"
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.itemSize = CGSize(width: 100.0, height: 100.0)
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: PageCollectionViewController.cellID)

        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
    }
}

extension PageCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PageCollectionViewController.cellID, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
}
