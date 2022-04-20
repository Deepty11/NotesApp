//
//  PracticePageViewController.swift
//  NotesApp
//
//  Created by Rehnuma Reza on 17/4/22.
//

import UIKit

class PracticePageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var quizzes: [QuizModel]{
        return DatabaseManager.shared.getAllQuiz()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setViewControllers([getViewController(for: 0)], direction: .forward, animated: true)
        
        self.configureNavigationBar()
    }
    
    func configureNavigationBar(){
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Practice"
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
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return quizzes.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentVc = pageViewController.viewControllers?.first as? CardViewController{
            return currentVc.pageIndex
        }
        return 0
    }

}
