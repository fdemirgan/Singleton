//
//  ViewController.swift
//  Singaleton
//
//  Created by Ferhat on 26.02.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var longitude: Double?
    var latitude: Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.delegate = self
    }


}

extension ViewController: LocationManagerDelegate {
    func didUpdateLocation(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
        print("""
              Diğer dosyadan
              \(longitude) ve
              \(latitude) verileri geldi.
              """)
    }
}
    
