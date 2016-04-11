//
//  ContentView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit

class ContentView: UIView {
    static let cellId = "cellId"
    lazy var collectionView: UICollectionView = {[weak self] in
        let flowLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView()

        if let strongSelf = self {
            flowLayout.itemSize = strongSelf.bounds.size
            flowLayout.scrollDirection = .Horizontal
            
            collection.frame = strongSelf.bounds
            collection.collectionViewLayout = flowLayout
            collection.pagingEnabled = true
            collection.delegate = strongSelf
            collection.dataSource = strongSelf
            collection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentView.cellId)

        }
        return collection
    }()
    

}

extension ContentView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ContentView.cellId, forIndexPath: indexPath)
        //
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        return cell
    }
    
    
}