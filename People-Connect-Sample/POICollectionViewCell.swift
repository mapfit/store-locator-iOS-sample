//
//  POICollectionViewCell.swift
//  People-Connect-Sample
//
//  Created by Zain N. on 3/13/18.
//  Copyright © 2018 Mapfit. All rights reserved.
//

import UIKit
import QuartzCore

class POICollectionViewCell: UICollectionViewCell {
    
    lazy var card: UIView = UIView()
    lazy var numberLabel: UILabel = UILabel()
    lazy var leftLabelStackView: UIStackView = UIStackView()
    lazy var rightLabelStackView: UIStackView = UIStackView()
    lazy var viewPropertyDetailsButton: UIButton = UIButton()
    
    lazy var leftSubtitle1: UILabel = UILabel()
    lazy var leftSubtitle2: UILabel = UILabel()
   
    lazy var rightSubtitle1: UILabel = UILabel()
    lazy var rightSubtitle2: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpCell(poi: POI){
        
       self.card.layer.cornerRadius = 9
       self.card.layer.masksToBounds = false
       self.card.backgroundColor = .white
       self.card.layer.shadowRadius = 1
       self.card.layer.shadowColor = UIColor(red: 19/255, green: 40/255, blue: 54/255, alpha: 0.2).cgColor
       self.card.layer.zPosition = 1
       self.card.layer.shadowOffset = CGSize(width: 0, height: 2)
       self.card.layer.shadowOpacity = 1
        
        
       self.contentView.addSubview(card)
       self.card.addSubview(numberLabel)
       self.card.addSubview(leftLabelStackView)
       self.card.addSubview(rightLabelStackView)
       //self.contentView.addSubview(viewPropertyDetailsButton)
        
        self.card.translatesAutoresizingMaskIntoConstraints = false
         self.numberLabel.translatesAutoresizingMaskIntoConstraints = false
         self.leftLabelStackView.translatesAutoresizingMaskIntoConstraints = false
         self.rightLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        // self.viewPropertyDetailsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.card.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.97).isActive = true
        self.card.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.97).isActive = true
        self.card.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.card.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true

        self.numberLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.numberLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.numberLabel.topAnchor.constraint(equalTo: self.card.topAnchor, constant: 15).isActive = true
        self.numberLabel.leadingAnchor.constraint(equalTo: self.card.leadingAnchor, constant: 15).isActive = true
        
        self.leftLabelStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.leftLabelStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.leftLabelStackView.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 15).isActive = true
        self.leftLabelStackView.leadingAnchor.constraint(equalTo: self.numberLabel.leadingAnchor).isActive = true
        
        self.rightLabelStackView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        self.rightLabelStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.rightLabelStackView.topAnchor.constraint(equalTo: self.numberLabel.bottomAnchor, constant: 15).isActive = true
        self.rightLabelStackView.trailingAnchor.constraint(equalTo: self.card.trailingAnchor, constant: -15).isActive = true
        
        
        self.leftLabelStackView.axis = .vertical
        self.rightLabelStackView.axis = .vertical
        
        self.leftLabelStackView.addArrangedSubview(leftSubtitle1)
        self.leftLabelStackView.addArrangedSubview(leftSubtitle2)
        self.rightLabelStackView.addArrangedSubview(rightSubtitle1)
        self.rightLabelStackView.addArrangedSubview(rightSubtitle2)
        
        
        self.numberLabel.textColor = UIColor(red: 68/255, green: 77/255, blue: 91/255, alpha: 1)
        self.leftSubtitle1.textColor = UIColor(red: 128/255, green: 138/255, blue: 152/255, alpha: 1)
        self.leftSubtitle2.textColor = UIColor(red: 128/255, green: 138/255, blue: 152/255, alpha: 1)
        self.rightSubtitle1.textColor = UIColor(red: 128/255, green: 138/255, blue: 152/255, alpha: 1)
        self.rightSubtitle2.textColor = UIColor(red: 128/255, green: 138/255, blue: 152/255, alpha: 1)
        //self.viewPropertyDetailsButton.titleLabel?.textColor = UIColor(red: 0/255, green: 158/255, blue: 255/255, alpha: 1)
        
        self.numberLabel.font = UIFont.boldSystemFont(ofSize: 18)
        self.leftSubtitle1.font = UIFont.systemFont(ofSize: 12)
        self.leftSubtitle2.font = UIFont.systemFont(ofSize: 12)
        self.rightSubtitle1.font = UIFont.systemFont(ofSize: 12)
        self.rightSubtitle2.font = UIFont.systemFont(ofSize: 12)
        self.rightSubtitle1.textAlignment = .right
        self.rightSubtitle2.textAlignment = .right
        //self.viewPropertyDetailsButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.numberLabel.text = poi.number
        self.leftSubtitle1.text = poi.address
        self.leftSubtitle2.text = "\(poi.city), \(poi.state), \(poi.zipCode)"
        self.rightSubtitle1.text = poi.primaryPhoneNumber
        self.rightSubtitle2.text = poi.secondaryPhoneNumber
        //self.viewPropertyDetailsButton.titleLabel?.text = "View Property Details"
    }
    
}
