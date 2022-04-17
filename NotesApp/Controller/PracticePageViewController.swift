//
//  PracticePageViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 17/4/22.
//

import UIKit

class PracticePageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var quizzes: [Quiz]{
        return DatabaseManager.shared.getAllQuiz()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setViewControllers([getViewController(for: 0)], direction: .forward, animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentVC = viewController as? CardViewController{
            let pageIndex = currentVC.pageIndex
            if pageIndex > 0{
                return getViewController(for: pageIndex - 1)
            }
        }
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentVC = viewController as? CardViewController{
            let pageIndex = currentVC.pageIndex
            if pageIndex < quizzes.count - 1{
                return getViewController(for: pageIndex + 1)
            }
        }
        return nil
    }
    
    func getViewController(for index: Int) -> UIViewController{
        if let vC = storyboard?.instantiateViewController(withIdentifier: String(describing: CardViewController.self)) as? CardViewController{
            vC.pageIndex = index
            vC.quiz = quizzes[index]
            return vC
            
        }
        return UIViewController()
        
    }

}
