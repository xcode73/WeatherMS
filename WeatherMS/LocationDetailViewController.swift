//
//  LocationDetailViewController.swift
//  WeatherMS
//
//  Created by Nikolai Eremenko on 04.05.2023.
//

import UIKit

class LocationDetailViewController: UIViewController {


    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var weatherLocation: WeatherLocation!
    var locationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        updateUserInterface()
    }
    
//    static func popToRootView() {
//            let scenes = UIApplication.shared.connectedScenes
//            let windowScene = scenes.first as? UIWindowScene
//            let window = windowScene?.windows.first
//
//            findNavigationController(viewController: window?.rootViewController)?
//                .popToRootViewController(animated: true)
//        }
    
    func updateUserInterface() {
//        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
                      
        let pageViewController = window?.rootViewController as! PageViewController
        
        weatherLocation = pageViewController.weatherLocations[locationIndex]
        
        dateLabel.text = ""
        placeLabel.text = weatherLocation.name
        temperatureLabel.text = "--°"
        summaryLabel.text = ""
        
        pageControl.numberOfPages = pageViewController.weatherLocations.count
        pageControl.currentPage = locationIndex
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LocationsListViewController
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
                      
        let pageViewController = window?.rootViewController as! PageViewController
        
        destination.weatherLocations = pageViewController.weatherLocations
    }
    
    @IBAction func unwindFromLocationListViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! LocationsListViewController
        locationIndex = source.selectedLocationIndex
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
                      
        let pageViewController = window?.rootViewController as! PageViewController
        
        pageViewController.weatherLocations = source.weatherLocations
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: locationIndex)], direction: .forward, animated: false)
    }
    
    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
                      
        let pageViewController = window?.rootViewController as! PageViewController
        
        var direction: UIPageViewController.NavigationDirection = .forward
        
        if sender.currentPage < locationIndex {
            direction = .reverse
        }
        pageViewController.setViewControllers([pageViewController.createLocationDetailViewController(forPage: sender.currentPage)], direction: direction, animated: true)
    }
}

