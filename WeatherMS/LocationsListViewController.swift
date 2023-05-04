//
//  LocationsListViewController.swift
//  WeatherMS
//
//  Created by Nikolai Eremenko on 03.05.2023.
//

import UIKit

class LocationsListViewController: UIViewController {
    
    @IBOutlet var tableVeiw: UITableView!
    @IBOutlet var editBarButton: UIBarButtonItem!
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    
    var weatherLocations:[WeatherLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var weatherLocation = WeatherLocation(name: "Samara", latitude: 0, longitude: 0)
        weatherLocations.append(weatherLocation)
        weatherLocation = WeatherLocation(name: "Ulianovsk", latitude: 0, longitude: 0)
        weatherLocations.append(weatherLocation)
        weatherLocation = WeatherLocation(name: "Ufa", latitude: 0, longitude: 0)
        weatherLocations.append(weatherLocation)
        
        tableVeiw.dataSource = self
        tableVeiw.delegate = self
    }
    

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableVeiw.isEditing {
            tableVeiw.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableVeiw.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    @IBAction func addLocationPressed(_ sender: UIBarButtonItem) {

    }
}

extension LocationsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = weatherLocations[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            weatherLocations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = weatherLocations[sourceIndexPath.row]
        weatherLocations.remove(at: sourceIndexPath.row)
        weatherLocations.insert(itemToMove, at: destinationIndexPath.row)
    }
}

