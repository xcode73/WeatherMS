//
//  LocationsListViewController.swift
//  WeatherMS
//
//  Created by Nikolai Eremenko on 03.05.2023.
//

import UIKit
import GooglePlaces

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
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
        
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
        content.secondaryText = "Lat:\(weatherLocations[indexPath.row].latitude) Lon:\(weatherLocations[indexPath.row].longitude)"
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

extension LocationsListViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let newLocation = WeatherLocation(name: place.name ?? "unknown place", latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        weatherLocations.append(newLocation)
        tableVeiw.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }

    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }

    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
