//
//  TypeView.swift
//  ScrollViewController
//
//  Created by jasnig on 16/4/29.
//  Copyright © 2016年 ZeroJ. All rights reserved.
// github: https://github.com/jasnig
// 简书: http://www.jianshu.com/users/fb31a3d1ec30/latest_articles

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


import UIKit

class HeadView: UICollectionReusableView {
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        label.textColor = UIColor.blackColor()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFontOfSize(16.0)
        return label
    }()
    
    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return onlyShowTheFirstSection ? 1 : 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedTitles.count
        } else {
            return unselectedTitles.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath) as! SelectionCollectionViewCell
        
        cell.state = onlyShowTheFirstSection ? .Selected : .Normal

        if indexPath.section == 0 {
            cell.title = selectedTitles[indexPath.row]
            cell.deleteAction = {[unowned self](btn: UIButton) in
                self.unselectedTitles.append(self.selectedTitles[indexPath.row])
                self.selectedTitles.removeAtIndex(indexPath.row)
                self.collectionView.reloadData()
            }

        } else {
            cell.title = unselectedTitles[indexPath.row]
            cell.selectedAction = {[unowned self](btn: UIButton) in
                self.selectedTitles.append(self.unselectedTitles[indexPath.row])
                self.unselectedTitles.removeAtIndex(indexPath.row)
                self.collectionView.reloadData()
            }
        }

        return cell
    }

    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeadView", forIndexPath: indexPath) as! HeadView
        if indexPath.section == 1 {
            headView.title = "   点击添加更多栏目"
        }
        return headView
    }


}

extension SelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSizeZero
        }
        return CGSize(width: 300, height: 44)
    }
    
}

class SelectionView: UIView {
    
    typealias FinishAction = (selectedTitles: [String]) -> Void
    private var snapedImageView: UIView!
    private var currentIndexPath:NSIndexPath?
    /// 正在动画中不要接受新的手势
    private var canRecieveTouch = true
    // 用于记录手势的位置和cell frame的最初的x和y的差距, 以用于同步更新位置
    private var deltaSize: CGSize!
    private let headViewHeight: CGFloat = 36.0
    
    private var unselectedTitles: [String] = []
    private var selectedTitles: [String] = []
    
    var finishAction: FinishAction?
    private lazy var panGes: UIPanGestureRecognizer! = {
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(self.pan(_:)))
        panGes.enabled = false
        return panGes

    }()

    /// 用于只显示第一组
    private var onlyShowTheFirstSection = false
    private var showFrame: CGRect!
    private var hideFrame: CGRect! {
        return CGRect(x: 0.0, y: -showFrame.size.height, width: showFrame.size.width, height: showFrame.size.height)
    }
    
    private var longPressedAction: (() -> Void)?
    
    init(frame: CGRect, selectedTitles: [String], unselectedTitles: [String], finishAction: FinishAction?) {
        self.selectedTitles = selectedTitles
        self.unselectedTitles = unselectedTitles
        self.finishAction = finishAction
        
        super.init(frame: frame)
        showFrame = frame
        backgroundColor = UIColor.brownColor()
        addSubview(collectionView)
        addHead()
    }
    
    deinit {
        print("\(self.debugDescription) --- 销毁")
    }
    
    func addHead() {
        let extraView = ExtraView.extraView({[unowned self] (editBtn) in // 编辑
                editBtn.selected = !editBtn.selected
                self.onlyShowTheFirstSection = editBtn.selected
                self.panGes.enabled = editBtn.selected

                self.collectionView.reloadData()
            }) {[unowned self] (finishBtn) in // 完成
                self.finishAction?(selectedTitles: self.selectedTitles)
                self.hide()
        }
        
        extraView.frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: headViewHeight)
        addSubview(extraView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .Vertical
        
        flow.itemSize = CGSize(width: (self.bounds.size.width - 5.0 * 10.0) / 4.0, height: 38.0)
        flow.sectionInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        flow.minimumLineSpacing = 5.0
        flow.minimumInteritemSpacing = 10.0
        
        let collectionView = UICollectionView(frame: CGRect(x: 0.0, y: self.headViewHeight, width: self.bounds.size.width, height: self.bounds.size.height - self.headViewHeight), collectionViewLayout: flow)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(HeadView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "HeadView")
        collectionView.registerNib(UINib(nibName : String(SelectionCollectionViewCell), bundle :nil), forCellWithReuseIdentifier: "cellID")
        collectionView.addGestureRecognizer(self.panGes)
        return collectionView
    }()
    
    func pan(ges: UIPanGestureRecognizer) {
        guard canRecieveTouch else { return }

        let location = ges.locationInView(self.collectionView)
        // 当手指的位置不在collectionView的cell范围内时为nil
        let notSureIndexPath = self.collectionView.indexPathForItemAtPoint(location)
        switch ges.state {
        case .Began:
            if let indexPath = notSureIndexPath { // 获取到的indexPath是有效的, 可以放心使用
                // 不要移动第一个 和只移动第一个section
                if indexPath.row == 0 || indexPath.section != 0 { return }
                
                currentIndexPath = indexPath
                let cell = collectionView.cellForItemAtIndexPath(indexPath)!
                snapedImageView = getTheCellSnap(cell)
                
                deltaSize = CGSize(width: location.x - cell.frame.origin.x, height: location.y - cell.frame.origin.y)
                
                snapedImageView.center = cell.center
                snapedImageView.transform = CGAffineTransformMakeScale(1.1, 1.1)
                cell.alpha = 0.0
        
                collectionView.addSubview(snapedImageView)
            }
        case .Changed:
            if snapedImageView == nil { return }
            // 同步改变位置
//            snapedImageView.center = location
            snapedImageView.frame.origin.x = location.x - deltaSize.width
            snapedImageView.frame.origin.y = location.y - deltaSize.height
            
            if let newIndexPath = notSureIndexPath, let oldIndexPath = currentIndexPath {
                if newIndexPath != oldIndexPath && newIndexPath.section == oldIndexPath.section && newIndexPath.row != 0 {// 只在同一组中移动且第一个不动
                    
                    // 更新数据源
                    if newIndexPath.row > oldIndexPath.row {
                        for index in oldIndexPath.row..<newIndexPath.row {
                            selectedTitles.exchangeObjectAtIndex(index, withObjectAtIndex: index + 1)
                        }
                    }
                    
                    if newIndexPath.row < oldIndexPath.row {
                        var index = oldIndexPath.row
                        for _ in newIndexPath.row..<oldIndexPath.row {

                            selectedTitles.exchangeObjectAtIndex(index, withObjectAtIndex: index - 1)
                            index -= 1
                        }
                    }

                    collectionView.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
                    

                    let cell = collectionView.cellForItemAtIndexPath(newIndexPath)
                    cell?.alpha = 0.0
                    currentIndexPath = newIndexPath
                }
                
            }
            
        case .Ended :
            
            if let oldIndexPath = currentIndexPath {
                let cell = collectionView.cellForItemAtIndexPath(oldIndexPath)!

                UIView.animateWithDuration(0.25, animations: {[unowned self] in
                        self.snapedImageView.transform = CGAffineTransformIdentity
                        self.snapedImageView.frame = cell.frame
                        self.canRecieveTouch = false
                    }, completion: {[unowned self] (_) in
                        self.snapedImageView.removeFromSuperview()
                        self.snapedImageView = nil
                        self.currentIndexPath = nil
                        cell.alpha = 1.0
                        self.canRecieveTouch = true
                        
                        
                })
            }
        default:
            // 恢复初始状态
            snapedImageView = nil
            currentIndexPath = nil
            canRecieveTouch = true
            
        }

    }

    func longPressed(ges: UILongPressGestureRecognizer) {
        onlyShowTheFirstSection = true
        ges.enabled = false
        collectionView.reloadData()
    }

    // 截图
    func getTheCellSnap(targetView: UIView) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0.0)
        
        targetView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let gottenImageView = UIImageView(image: image)

        return gottenImageView
    }
    
    func show() {
        
        frame = hideFrame
        UIView.animateWithDuration(0.3, animations: {[unowned self] in
            self.frame = self.showFrame
            
            }) { (_) in
                
        }
        
    }
    
    func hide() {
        
        UIView.animateWithDuration(0.3, animations: {
            self.frame = self.hideFrame
            
        }) {[unowned self] (_) in
            
            self.removeFromSuperview()
        }
    }

}

extension Array {
    mutating func exchangeObjectAtIndex(index: Int, withObjectAtIndex newIndex: Int) {
        let temp = self[index]
        self[index] = self[newIndex]
        self[newIndex] = temp
    }
}
