//
//  ManagePageViewController.swift
//  XCARET!
//
//  Created by Angelica Can on 7/18/19.
//  Copyright © 2019 Angelica Can. All rights reserved.
//

import UIKit

class ManagePageViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionActivities: UICollectionView!
    @IBOutlet weak var topCollectionView: NSLayoutConstraint!
    
    let typeCell: String = "DEF"
    var pageSelectTag : Int = 0
    var dataSource : [ItemActivity] = [ItemActivity]()
    var currentViewControllerIndex = 0
    var isFirstLoad = true
    let pageViewController = AppStoryboard.ParkXenses.instance.instantiateViewController(withIdentifier: String(describing: CustomPageViewController.self)) as? CustomPageViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.topCollectionView.constant = UIDevice().getTopCollection()
        // Do any additional setup after loading the view.
        
        if dataSource.count > 0 {
            configureCollectionView()
            configurePageViewController()
        }
    }
    
    func configureCollectionView(){
        //Config de collection horarios
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.minimumLineSpacing = 5.0
        flowLayout.minimumInteritemSpacing = 5.0
        self.collectionActivities.collectionViewLayout = flowLayout
        self.collectionActivities.showsHorizontalScrollIndicator = false
        self.collectionActivities.decelerationRate = UIScrollView.DecelerationRate.fast
        self.collectionActivities.delegate = self
        self.collectionActivities.dataSource = self
        
        self.selectCellCollView(indexPath: IndexPath(item: currentViewControllerIndex, section: 0))
    }
    
    func configurePageViewController(){
        
        pageViewController!.delegate = self
        pageViewController!.dataSource = self
        addChild(pageViewController!)
        pageViewController!.didMove(toParent: self)
        pageViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pageViewController!.view)
        let views : [String : Any] = ["pageView" : pageViewController!.view!]
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|",
                                                                  options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                  metrics: nil,
                                                                  views: views))
        
        self.selectPageViewController(index: currentViewControllerIndex)
        
    }

    func detailViewControllerAt(index: Int) -> DataActivityViewController?{
        if index >= dataSource.count || dataSource.count == 0 {
            return nil
        }
        guard let dataViewController = AppStoryboard.ParkXenses.instance.instantiateViewController(withIdentifier: String(describing: DataActivityViewController.self)) as? DataActivityViewController else {
            return nil
        }
        print("ACTION detailViewController : \(index)")
        dataViewController.index = index
        dataViewController.view.tag = index
        dataViewController.itemActivity = dataSource[index]
        return dataViewController
    }
    
    private func selectCellCollView(indexPath: IndexPath){
         print("ACTION selectCellCollView : \(indexPath.row)")
        self.collectionActivities.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    private func selectPageViewController(index: Int){
         print("ACTION selectPageViewController : \(index)")
        guard let startingViewController = detailViewControllerAt(index: index) else {
            return
        }
            if index > currentViewControllerIndex{
                pageViewController!.setViewControllers([startingViewController], direction: .forward, animated: true)
            }else{
                pageViewController!.setViewControllers([startingViewController], direction: .reverse, animated: true)
            }
        
    }
}

extension ManagePageViewController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentViewControllerIndex
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataActivityViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        print("ACTION Before : \(currentIndex)")
        currentViewControllerIndex = currentIndex
        if currentIndex == 0 {
            return nil
        }
        currentIndex -= 1
        return detailViewControllerAt(index: currentIndex )
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataActivityViewController
        guard var currentIndex = dataViewController?.index else {
            return nil
        }
        print("ACTION after : \(currentIndex)")
        if currentIndex == dataSource.count {
            return  nil
        }
        
        currentIndex += 1
        currentViewControllerIndex = currentIndex
        return detailViewControllerAt(index: currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed)
        {
            return
        }
        let indexPage = pageViewController.viewControllers!.first!.view.tag //Page Index
        let indexPathCV = IndexPath(item: indexPage, section: 0)
        self.selectCellCollView(indexPath: indexPathCV)
        print("ACTION didFinishAnimating \(indexPage)")
    }
}

extension ManagePageViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellName", for: indexPath) as! ItemNameCollectionViewCell
        cell.itemActivity = dataSource[indexPath.row]
        cell.configureCell(item: dataSource[indexPath.row])
        //cell.backgroundColor = UIColor.green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: self.view.frame.width * 0.5 , height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let width = collectionView.frame.width
        let margin = width * 0.5
        return UIEdgeInsets(top: 0, left: margin / 2, bottom: 0, right: margin / 2)
    }
    
    
    /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.frame.width * 0.5 / 2
    }*/
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionActivities.contentOffset
        visibleRect.size = collectionActivities.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = collectionActivities.indexPathForItem(at: visiblePoint) else { return }
        print("Scroll \(indexPath.row) != \(currentViewControllerIndex)")
        //if indexPath.row != currentViewControllerIndex {
            print("Scroll Mueve pagina")
            self.selectCellCollView(indexPath: indexPath)
            self.selectPageViewController(index: indexPath.row)
        //}
    }
    
}
