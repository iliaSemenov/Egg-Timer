//
// Egg Timer App
// Created by Semenov Ilia
// Copyright © 2017 Semenov Ilia. All rights reserved.
//

import UIKit

protocol EggPagerDelegate
{
    func numberOfpage(number: Int)
}

class EggPager: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource
{
    var appController = AppController()
    
    var pageDelegate: EggPagerDelegate?

    var viewsArray: [UIViewController] = []
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    var currentIndex = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        pageSettings()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func pageSettings()
    {
        let pageOne = storyBoard.instantiateViewController(withIdentifier: "EggStateOne")
        let pageTwo = storyBoard.instantiateViewController(withIdentifier: "EggStateTwo")
        let pageThree = storyBoard.instantiateViewController(withIdentifier: "EggStateThree")
        
        viewsArray.append(pageOne)
        viewsArray.append(pageTwo)
        viewsArray.append(pageThree)
        
        setViewControllers([viewsArray[currentIndex]], direction: .forward, animated: true, completion: nil)
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        currentIndex = viewsArray.index(of: viewController)!
        getPageNumber()
        
        if currentIndex == 2
        {
            return nil
        }
        else
        {
            let nextIndex = abs((currentIndex + 1) % viewsArray.count)
            return viewsArray[nextIndex]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        currentIndex = viewsArray.index(of: viewController)!
        getPageNumber()
        
        if currentIndex == 0
        {
            return nil
        }
        else
        {
            let previousIndex = abs((currentIndex - 1) % viewsArray.count)
            return viewsArray[previousIndex]
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return viewsArray.count
    }
    
    func getPageNumber()
    {
        pageDelegate?.numberOfpage(number: currentIndex)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }

}
