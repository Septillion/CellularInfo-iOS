//
//  DetailedNetworkInformation.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//

import Foundation

class DetailedNetworkInformation:ObservableObject {
    @Published var pingNumberAveraged : Double = 0
    @Published var pingNumberDouble : [Double] = []
    @Published var pingNumberCurrent: Double = 0
    
    init() {
        
    }
}
