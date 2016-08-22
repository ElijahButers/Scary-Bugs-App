//
//  ScaryBug.swift
//  Scary Bugs
//
//  Created by Brian on 10/6/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import UIKit

enum ScaryFactor: Int {
    case notScary
    case aLittleScary
    case averageScary
    case quiteScary
    case aiiiiieeeee
    case totalBugs
}

class ScaryBug {
  
  var name: String
  var image: UIImage?
  var howScary: ScaryFactor
  
  init(withName name: String, imageName: String?, howScary: ScaryFactor) {
    self.name = name
    self.howScary = howScary
    if let imageName = imageName {
      if let image = UIImage(named: imageName) {
        self.image = image
      }
    }
  }
  
  static func scaryFactorToString(scaryFactor:ScaryFactor) -> String {
    var scaryString = ""
    switch(scaryFactor) {
      case .notScary:
        scaryString = "Not scary"
    case .aLittleScary:
        scaryString = "A little scary"
    case .averageScary:
        scaryString = "Average scariness"
    case .quiteScary:
        scaryString = "Quite scary"
    case .aiiiiieeeee:
        scaryString = "AIIIIIEEEEEEE!!"
    case .totalBugs:
        scaryString = ""
    }
    return scaryString
  }
  
  static func bugs() -> [ScaryBug] {
    var bugs = [ScaryBug]()
    bugs.append(ScaryBug(withName: "Centipede", imageName: "centipede.jpg", howScary: .averageScary))
    bugs.append(ScaryBug(withName: "Ladybug", imageName: "ladybug.jpg", howScary: .notScary))
    bugs.append(ScaryBug(withName: "Potato Bug", imageName: "potatoBug.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Wolf Spider", imageName: "wolfSpider.jpg", howScary: .aiiiiieeeee))
    bugs.append(ScaryBug(withName: "Bee", imageName: "bee.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Beetle", imageName: "beetle.jpg", howScary: .aLittleScary))
    bugs.append(ScaryBug(withName: "Burrito Insect", imageName: "burritoInsect.jpg", howScary: .averageScary))
    bugs.append(ScaryBug(withName: "Caterpillar", imageName: "caterpillar.jpg", howScary: .notScary))
    bugs.append(ScaryBug(withName: "Cicada", imageName: "cicada.jpg", howScary: .averageScary))
    bugs.append(ScaryBug(withName: "Cockroach", imageName: "cockroach.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Exoskeleton", imageName: "exoskeleton.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Fly", imageName: "fly.jpg", howScary: .notScary))
    bugs.append(ScaryBug(withName: "Giant Moth", imageName: "giantMoth.jpg", howScary: .averageScary))
    bugs.append(ScaryBug(withName: "Grasshopper", imageName: "grasshopper.jpg", howScary: .aiiiiieeeee))
    bugs.append(ScaryBug(withName: "Mosquito", imageName: "mosquito.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Praying Mantis", imageName: "prayingMantis.jpg", howScary: .notScary))
    bugs.append(ScaryBug(withName: "Roach", imageName: "roach.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Robber Fly", imageName: "robberFly.jpg", howScary: .quiteScary))
    bugs.append(ScaryBug(withName: "Scorpion", imageName: "scorpion.jpg", howScary: .aiiiiieeeee))
    bugs.append(ScaryBug(withName: "Shield Bug", imageName: "shieldBug.jpg", howScary: .averageScary))
    bugs.append(ScaryBug(withName: "Stag Beetle", imageName: "stagBeetle.jpg", howScary: .averageScary))
    bugs.append(ScaryBug(withName: "Stink Bug", imageName: "stinkbug.jpg", howScary: .aLittleScary))
    return bugs
  }

}
