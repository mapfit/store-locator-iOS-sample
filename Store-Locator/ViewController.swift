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
    var neighborhood: String
    
    
    init(number: String, address: String, city: String, state: String, zipCode: String, primaryPhoneNumber: String, secondaryPhoneNumber: String, coordinate: CLLocationCoordinate2D, neighborhood: String){
        self.number = number
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.primaryPhoneNumber = primaryPhoneNumber
        self.secondaryPhoneNumber = secondaryPhoneNumber
        self.coordinate = coordinate
        self.neighborhood = neighborhood
    }
    
}

class ViewController: UIViewController {
    
    var mapView = MFTMapView()
    var layout = SnappingCollectionViewLayout()
    var collectionView: UICollectionView?
    var locations = [POI]()
    var currentPolyline: MFTPolyline?
    var initialZoom: Float = 12.5
    var initialRotation: Float = 2.05
    var initialTilt: Float = 0.85
    var homeAnimationDuration: Float = 0.5
    var initialCenter: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.73748242049333, longitude: -73.95733284034074)

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "house"), style: .plain, target: self, action: #selector(homeButtonTapped))
        let githubButton = UIBarButtonItem(image: #imageLiteral(resourceName: "github"), style: .plain, target: self, action: #selector(githubButtonTapped))
        self.navigationItem.leftBarButtonItem = homeButton
        self.navigationItem.rightBarButtonItem = githubButton
        self.navigationItem.title = "Coffee Shop Locations"
        mapView.markerSelectDelegate = self
        loadData()
        setUpMap()
        setUpCollectionView()

    }
    
    @objc func homeButtonTapped(){
        let queue: OperationQueue = OperationQueue()
        queue.maxConcurrentOperationCount = (4)
        queue.addOperation({self.mapView.setCenter(position: self.initialCenter, duration: self.homeAnimationDuration)})
        queue.addOperation({self.mapView.setZoom(zoomLevel: self.initialZoom, duration: self.homeAnimationDuration)})
        queue.addOperation({self.mapView.setRotation(rotationValue: self.initialRotation, duration: self.homeAnimationDuration)})
        queue.addOperation({self.mapView.setTilt(tiltValue: self.initialTilt, duration: self.homeAnimationDuration)})
    }
    
    @objc func githubButtonTapped(){
        if let url = URL(string: "https://github.com/mapfit/store-locator-iOS-sample"){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    func setUpMap(){
        mapView.frame = view.bounds
        mapView.mapOptions.setTheme(theme: .day)
        view.addSubview(mapView)
        view.sendSubview(toBack: mapView)
        mapView.setZoom(zoomLevel: self.initialZoom)
        mapView.setTilt(tiltValue: self.initialTilt)
        mapView.setRotation(rotationValue: self.initialRotation)
        mapView.setCenter(position: self.initialCenter)
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
        collectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        //collectionView.isPagingEnabled = true
        collectionView.decelerationRate = 2
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        //collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
    }
    
    override func viewDidLayoutSubviews() {
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "poiCell",
                                                      for: indexPath) as! POICollectionViewCell
        cell.setUpCell(poi: locations[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.9, height: 121)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 18, 0, 18)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //snapToCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
       snapToCell()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.velocity(in: view).x > 300 {
            guard let collectionView = self.collectionView else { return }
            
            let center = self.view.convert(collectionView.center, to: collectionView)
            
            if var index = collectionView.indexPathForItem(at: center) {
                
                if index.row != 0 {
                    index.row -= 1
                }
                
                
                
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.zoomAndCenter(zoom: 17, coordinate: locations[index.row].coordinate, duration: 0.6)
            }else {
                self.zoomAndCenter(zoom: 17, coordinate: locations[collectionView.indexPathsForVisibleItems[0].row].coordinate, duration: 0.6)
            }
        }else if scrollView.panGestureRecognizer.velocity(in: view).x < -300 {
        
            guard let collectionView = self.collectionView else { return }
            
            let center = self.view.convert(collectionView.center, to: collectionView)
            
            if var index = collectionView.indexPathForItem(at: center) {
                if index.row != locations.count - 1 {
                    index.row += 1
                }
                collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
                self.zoomAndCenter(zoom: 17, coordinate: locations[index.row].coordinate, duration: 0.6)
            }else {
                self.zoomAndCenter(zoom: 17, coordinate: locations[collectionView.indexPathsForVisibleItems[0].row].coordinate, duration: 0.6)
            }
        
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
       //snapToCell()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //snapToCell()
    }

    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //snapToCell()
    }

    @objc func snapToCell(){
        guard let collectionView = self.collectionView else { return }
        
        let center = self.view.convert(collectionView.center, to: collectionView)
        
        if let index = collectionView.indexPathForItem(at: center) {
           
            //collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            self.zoomAndCenter(zoom: 17, coordinate: locations[index.row].coordinate, duration: 0.3)
        }else {
            self.zoomAndCenter(zoom: 17, coordinate: locations[collectionView.indexPathsForVisibleItems[0].row].coordinate, duration: 0.3)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.zoomAndCenter(zoom: 17, coordinate:  locations[indexPath.row].coordinate, duration: 0.2)
        
    }
}

enum cellPostion {
    case previous, center, next
}

extension ViewController: MapMarkerSelectDelegate {
    func mapView(_ view: MFTMapView, didSelectMarker marker: MFTMarker, atScreenPosition position: CGPoint) {
        for location in locations {
            if location.marker == marker {
                collectionView?.scrollToItem(at: IndexPath(item: Int(location.number)! - 1, section: 0), at: .centeredHorizontally, animated: true)
                self.zoomAndCenter(zoom: 17, coordinate: location.coordinate, duration: 0.2)
            }
        }
    }
}

extension ViewController {
   
    func loadData(){
        let dummyCell1 = POI(number: "1", address: "450 W 15th Street", city: "Manhattan", state: "NY", zipCode: "10014", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0164", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324), neighborhood: "Chelsea")
        
        let dummyCell2 = POI(number: "2", address: "54 W 40th Street", city: "Manhattan", state: "NY", zipCode: "10018", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0115", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938), neighborhood: "Bryant Park")
        
        let dummyCell3 = POI(number: "3", address: "60 E 42nd Street", city: "Manhattan", state: "NY", zipCode: "10165", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0115", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939), neighborhood: "Grand Central Place")
        
        let dummyCell4 = POI(number: "4", address: "1 Rockefeller Plaza, Suite D", city: "Manhattan", state: "NY", zipCode: "10020", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0127", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324), neighborhood: "Rockefeller Center")
        
        let dummyCell5 = POI(number: "5", address: "10 E 53rd Street", city: "Manhattan", state: "NY", zipCode: "10022", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0175", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938), neighborhood: "Midtown East")
        
        let dummyCell6 = POI(number: "6", address: "71 Clinton Street", city: "Manhattan", state: "NY", zipCode: "10002", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0171", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939), neighborhood: "Clinton Street")
        
        let dummyCell7 = POI(number: "7", address: "85 Dean Street ", city: "Brooklyn", state: "NY", zipCode: "11201", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0160", coordinate: CLLocationCoordinate2D(latitude: 40.748, longitude: -73.9938), neighborhood: "Dean Street")
        
        let dummyCell8 = POI(number: "8", address: "76 N. 4th Street, Store A", city: "Brooklyn", state: "NY", zipCode: "11249", primaryPhoneNumber: "(646) 336-6462", secondaryPhoneNumber: "(202) 555-0116", coordinate: CLLocationCoordinate2D(latitude: 40.7441, longitude: -73.9939), neighborhood: "Williamsburg")
        
        let dummyCell9 = POI(number: "9", address: "150 Greenwich St", city: "Manhattan", state: "NY", zipCode: "10007", primaryPhoneNumber: "(347) 387-7428", secondaryPhoneNumber: "(202) 555-0190", coordinate: CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324), neighborhood: "World Trade Center")
        
        let dummyCell10 = POI(number: "10", address: "101 University Place", city: "Manhattan", state: "NY", zipCode: "10003", primaryPhoneNumber: "(212) 947-3860", secondaryPhoneNumber: "(202) 555-0116", coordinate:CLLocationCoordinate2D(latitude: 40.74405, longitude: -73.99324), neighborhood: "University Place")


        locations.append(dummyCell1)
        locations.append(dummyCell2)
        locations.append(dummyCell3)
        locations.append(dummyCell4)
        locations.append(dummyCell5)
        locations.append(dummyCell6)
        locations.append(dummyCell7)
        locations.append(dummyCell8)
        locations.append(dummyCell9)
        locations.append(dummyCell10)
 
        for location in locations {
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

class SnappingCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left + 18
        
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        
        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}



