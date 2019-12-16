//
//  SlideViewController.swift
//  weatherapp
//
//  Created by Ярослав on 10/23/19.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit


class SlideViewController: UIPageViewController {
    let weatherUrl = "https://www.metaweather.com/api/location/" + "924938";
    var weather: Weather!
    private(set) var orderedViewControllers: [UIViewController] = {
        return [SlideViewController.newColoredViewController(name: "CurrentWeather"),
                SlideViewController.newColoredViewController(name: "CurrentWeather"),
                SlideViewController.newColoredViewController(name: "CurrentWeather"),
                SlideViewController.newColoredViewController(name: "CurrentWeather"),
                SlideViewController.newColoredViewController(name: "CurrentWeather"),
                SlideViewController.newColoredViewController(name: "CurrentWeather")]
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        loadWeather()
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    private class func newColoredViewController(name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    func loadWeather(){
        let url = URL(string: self.weatherUrl);
        let request: URLRequest = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request) {(d, resp, err) in
            if err != nil { return }
            self.weather = try? JSONDecoder().decode(Weather.self, from: d!)
            guard let view = self.orderedViewControllers.first as? PresendDayVC else { return }
            view.cityName = self.weather.title
            view.currentWeather = self.weather.weatherElements?.first
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: nil)
            }
        }.resume()
    }
}

extension SlideViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard var index = orderedViewControllers.index(of: viewController) else { return nil }
        index += 1
        let orderedViewControllersCount = orderedViewControllers.count
        if index < 0 { index = orderedViewControllersCount }
        if index >= orderedViewControllersCount { index = 0 }
        guard let newViewController = orderedViewControllers[index] as? PresendDayVC else { return orderedViewControllers[index] }
        newViewController.cityName = weather.title
        newViewController.currentWeather = weather.weatherElements?[index]
        return newViewController
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard var index = orderedViewControllers.index(of: viewController) else { return nil }
        index -= 1
        let orderedViewControllersCount = orderedViewControllers.count
        if index < 0 { index = orderedViewControllersCount - 1 }
        if index >= orderedViewControllersCount { index = 0 }
        guard let newViewController = orderedViewControllers[index] as? PresendDayVC else { return orderedViewControllers[index] }
        newViewController.cityName = weather.title
        newViewController.currentWeather = weather.weatherElements?[index]
        return newViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
}
