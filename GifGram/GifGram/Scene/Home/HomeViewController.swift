//
//  ViewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit

class HomeViewController: UIViewController {

    var pageController: UIPageViewController!
    var viewControllers = NSMutableArray()
    var currentPageIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let firstViewController = storyboard.instantiateViewController(withIdentifier: "trendPage")
        firstViewController.view.tag = 0
        viewControllers.add(firstViewController)
        
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "searchPage")
        secondViewController.view.tag = 1
        viewControllers.add(secondViewController)
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation:.horizontal, options: nil)
        
        pageController.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - (self.tabBarController?.tabBar.frame.size.height ?? 0));
        
        currentPageIndex = 0
        pageController.setViewControllers([viewControllers.object(at: currentPageIndex) as! UIViewController], direction: .forward, animated: false) {(isFinished:Bool) -> Void in
            
        }
        
        self.addChild(pageController)
        self.view.addSubview(pageController.view)
    }

}
