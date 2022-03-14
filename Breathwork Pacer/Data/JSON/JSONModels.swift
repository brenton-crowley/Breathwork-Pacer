//
//  BreathSet.swift
//  Breathwork Pacer
//
//  Created by Brent on 15/3/2022.
//

import Foundation

struct BreathSetJSON: Decodable {
    
    var title:String
    var steps:[BreathStepJSON]
    
}

struct BreathStepJSON: Decodable {
    
    var type:String
    var duration:Double
    
}
