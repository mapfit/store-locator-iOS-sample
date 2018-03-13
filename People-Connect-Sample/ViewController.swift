//
//  ViewController.swift
//  People-Connect-Sample
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "house"), style: .plain, target: self, action: #selector(homeButtonTapped))
        self.navigationItem.leftBarButtonItem = homeButton
        mapView.markerSelectDelegate = self
        
        /*
         Starbucks,525 W 26TH ST,MANHATTAN,NY,10001
         Starbucks,205 WEST   34 STREET,MANHATTAN,NY,10001
         Starbucks,151 WEST 34TH STREET,MANHATTAN,NY,10001
         Starbucks,875 6 AVENUE,MANHATTAN,NY,10001
         Starbucks,229 SEVENTH AVENUE,MANHATTAN,NY,10011
         Starbucks,177 8 AVENUE,MANHATTAN,NY,10011
         Starbucks,227 WEST   27 STREET,MANHATTAN,NY,10001
         Starbucks,776 AVENUE OF THE AMERICAS,MANHATTAN,NY,10001
         Starbucks,124 8 AVENUE,MANHATTAN,NY,10011
         Starbucks,370 7 AVENUE,MANHATTAN,NY,10001
         
         (202) 555-0164
         (202) 555-0115
         (202) 555-0127
         (202) 555-0138
         (202) 555-0175
         (202) 555-0142
         (202) 555-0171
         (202) 555-0160
         (202) 555-0196
         (202) 555-0116
         (202) 555-0190
         (202) 555-0116
        */
        
        var dummyCell1 = POI(number: "1", address: "525 w 26th St", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0164", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        var dummyCell2 = POI(number: "2", address: "205 w 34th St", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0115", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938))
        
        var dummyCell3 = POI(number: "3", address: "494 8th Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0115", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939))
        
        var dummyCell4 = POI(number: "4", address: "875 6 Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0127", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        var dummyCell5 = POI(number: "5", address: "122 Greenwich Avenue", city: "Manhattan", state: "NY", zipCode: "10011", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0175", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938))
        
        var dummyCell6 = POI(number: "6", address: "177 8th Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0171", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939))
        
        var dummyCell7 = POI(number: "7", address: "227 w 27 St", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0160", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938))
        
        var dummyCell8 = POI(number: "8", address: "776 Avenue of the Americas", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0116", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939))
        
        var dummyCell9 = POI(number: "9", address: "124 8th Avenue", city: "Manhattan", state: "NY", zipCode: "10001", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0190", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))
        
        var dummyCell10 = POI(number: "10", address: "74 7th Ave", city: "Manhattan", state: "NY", zipCode: "10011", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0116", coordinate:CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324))

        
        
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
        
        
        setUpMap()
        setUpCollectionView()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUpMap(){
        mapView.frame = view.bounds
        self.view.addSubview(mapView)
        self.view.sendSubview(toBack: mapView)
        mapView.setZoom(zoomLevel: 14.5)
        self.mapView.setCenter(position: CLLocationCoordinate2D(latitude: 40.743621, longitude: -73.99594919012681))
    }
    


    @objc func homeButtonTapped(){
        
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
        collectionView.heightAnchor.constraint(equalToConstant: 113).isActive = true
       //collectionView.isPagingEnabled = true
        
        
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
        return CGSize(width: 268, height: 100)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        mapView.setZoom(zoomLevel: 17)
        mapView.setCenter(position: peopleConnectLocations[indexPath.row].coordinate, duration: 1)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if let cV = collectionView {
            if let path = cV.indexPathForItem(at: cV.center) {
            collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            mapView.setCenter(position: peopleConnectLocations[path.row].coordinate, duration: 1)
            }
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 60)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: Float = 248
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if newTargetOffset > Float(scrollView.contentSize.width) {
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: 0), animated: true)
    }
    

    
}

extension ViewController: MapMarkerSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint) {
        for location in peopleConnectLocations {
            if location.marker == marker {
                
                collectionView?.scrollToItem(at: IndexPath(item: Int(location.number)! - 1, section: 0), at: .centeredHorizontally, animated: true)
            }
            
        }
    }
    
    
}


