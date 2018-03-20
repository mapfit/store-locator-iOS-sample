//
//  ViewController.swift
//  Store-Locator
//
//  Created by Zain N. on 3/13/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import Mapfit
import CoreLocation

final class POI {
    
    var number: String
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var primaryPhoneNumber: String
    var secondaryPhoneNumber: String
    var coordinate: CLLocationCoordinate2D
    var marker: MFTMarker?
    
    
    init(number: String, address: String, city: String, state: String, zipCode: String, primaryPhoneNumber: String, secondaryPhoneNumber: String, coordinate: CLLocationCoordinate2D){
        self.number = number
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.primaryPhoneNumber = primaryPhoneNumber
        self.secondaryPhoneNumber = secondaryPhoneNumber
        self.coordinate = coordinate
    }
    
}

class ViewController: UIViewController {
    
    var mapView = MFTMapView()
    var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView?
    var peopleConnectLocations = [POI]()

    //properties to calculate scrolling velocity
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "house"), style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.leftBarButtonItem = homeButton
        mapView.markerSelectDelegate = self
        loadData()
        setUpMap()
        setUpCollectionView()

    }
    
    @objc func homeButtonTapped(){
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = (4)
        queue.addOperation({self.mapView.setCenter(position: CLLocationCoordinate2D(latitude: 40.743075076735416, longitude: -73.99652806346154), duration: 0.5)})
        queue.addOperation({self.mapView.setZoom(zoomLevel: 15, duration: 0.5)})
        queue.addOperation({self.mapView.setRotation(rotationValue: 0.1, duration: 0.5)})
        queue.addOperation({self.mapView.setTilt(tiltValue: 1, duration: 0.5)})
    }
    
    func setUpMap(){
        mapView.frame = view.bounds
        mapView.mapOptions.setTheme(theme: .day)
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        mapView.setZoom(zoomLevel: 15)
        mapView.setTilt(tiltValue: 1)
        mapView.setRotation(rotationValue: 0.1)
        mapView.setCenter(position: CLLocationCoordinate2D(latitude: 40.743075076735416, longitude: -73.99652806346154))
    }
    
    func zoomAndCenter(zoom: Float, coordinate: CLLocationCoordinate2D, duration: Float){
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = (2)
        queue.addOperation({self.mapView.setCenter(position: coordinate, duration: duration)})
        queue.addOperation({self.mapView.setZoom(zoomLevel: zoom, duration: duration)})
    }
    

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setUpCollectionView(){
        self.layout.scrollDirection = .horizontal
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = self.collectionView else { return }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        collectionView.register(POICollectionViewCell.self, forCellWithReuseIdentifier: "poiCell")
        
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -18).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 127).isActive = true
        //collectionView.isPagingEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    override func viewDidLayoutSubviews() {
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "poiCell",
                                                      for: indexPath) as! POICollectionViewCell
        cell.setUpCell(poi: peopleConnectLocations[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peopleConnectLocations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.9, height: 125)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 18, 0, 18)
    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        snapToCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        snapToCell()
    }
    

    @objc func snapToCell(){
        guard let collectionView = self.collectionView else { return }
        let center = self.view.convert(collectionView.center, to: collectionView)
        
        if let index = collectionView.indexPathForItem(at: center) {
            collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.zoomAndCenter(zoom: 17, coordinate: peopleConnectLocations[index.row].coordinate, duration: 0.2)
        }else {
            self.zoomAndCenter(zoom: 17, coordinate: peopleConnectLocations[collectionView.indexPathsForVisibleItems[0].row].coordinate, duration: 0.2)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.zoomAndCenter(zoom: 17, coordinate:  peopleConnectLocations[indexPath.row].coordinate, duration: 0.2)
        
    }
}

extension ViewController: MapMarkerSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint) {
        for location in peopleConnectLocations {
            if location.marker == marker {
                collectionView?.scrollToItem(at: IndexPath(item: Int(location.number)! - 1, section: 0), at: .centeredHorizontally, animated: true)
                self.zoomAndCenter(zoom: 17, coordinate: location.coordinate, duration: 0.2)
            }
        }
    }
}

extension ViewController {
    func loadData(){
        let dummyCell1 = POI(number: "1", address: "525 w 26th St", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0164", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        let dummyCell2 = POI(number: "2", address: "205 w 34th St", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0115", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938))
        
        let dummyCell3 = POI(number: "3", address: "494 8th Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0115", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939))
        
        let dummyCell4 = POI(number: "4", address: "875 6 Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0127", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        let dummyCell5 = POI(number: "5", address: "122 Greenwich Avenue", city: "Manhattan", state: "NY", zipCode: "10011", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0175", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938))
        
        let dummyCell6 = POI(number: "6", address: "177 8th Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0171", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939))
        
        let dummyCell7 = POI(number: "7", address: "227 w 27 St", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0160", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938))
        
        let dummyCell8 = POI(number: "8", address: "776 Avenue of the Americas", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0116", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939))
        
        let dummyCell9 = POI(number: "9", address: "124 8th Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0190", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        let dummyCell10 = POI(number: "10", address: "74 7th Ave", city: "Manhattan", state: "NY", zipCode: "10011", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0116", coordinate:CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))

        peopleConnectLocations.append(dummyCell1)
        peopleConnectLocations.append(dummyCell2)
        peopleConnectLocations.append(dummyCell3)
        peopleConnectLocations.append(dummyCell4)
        peopleConnectLocations.append(dummyCell5)
        peopleConnectLocations.append(dummyCell6)
        peopleConnectLocations.append(dummyCell7)
        peopleConnectLocations.append(dummyCell8)
        peopleConnectLocations.append(dummyCell9)
        peopleConnectLocations.append(dummyCell10)
 
        for location in peopleConnectLocations {
            mapView.addMarker(address: "\(location.address), \(location.city), \(location.state), \(location.zipCode)") { (marker, error) in
                if let image = UIImage(named: location.number) {
                    marker?.setIcon(image)
                }
                if let position = marker?.position {
                    location.coordinate = position
                    location.marker = marker
                    
                }
            }
        }
    }
}



