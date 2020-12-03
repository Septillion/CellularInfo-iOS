//
//  PingListItem.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/9.
//

import SwiftUI

struct DomainAndPing: Identifiable {
    var id: Int
    var domain : String
    var ping : Double
    var latencyString: String = ""
    var latencyColor = Color(.label)
    
    init(id: Int, domain: String, ping: Double) {
        self.id = id
        self.domain = domain
        self.ping = ping
    }
    
    mutating func setPing(ping: Double){
        self.ping = ping
        
        if self.ping < 100 {
            self.latencyColor = Color(.systemGreen)
        }
        if (self.ping >= 100)&&( self.ping < 200) {
            self.latencyColor = Color(.systemOrange)
        }
        if self.ping >= 200 {
            self.latencyColor = Color(.systemRed)
        }
        
        self.latencyString = "\(String(format: "%.1f", self.ping))ms"
        
        
        if self.ping == 0 {
            self.latencyString = ""
        }
        
        if self.ping == 999999 {
            self.latencyString = "timeout"
            self.latencyColor = Color(.systemGray)
        }
    }
}

class AGroupOfDomainsAndPings : ObservableObject {
    
    @Published var daps = [DomainAndPing(id: 1, domain: "qq.com", ping: 0),
                           DomainAndPing(id: 2, domain: "weibo.com", ping: 0),
                           DomainAndPing(id: 3, domain: "toutiao.com", ping: 0),
                           DomainAndPing(id: 4, domain: "taobao.com", ping: 0),
                           DomainAndPing(id: 5, domain: "jd.com", ping: 0),
                           DomainAndPing(id: 6, domain: "bilibili.com", ping: 0),
                           DomainAndPing(id: 7, domain: "163.com", ping: 0),
                           DomainAndPing(id: 8, domain: "iqiyi.com", ping: 0),
                           DomainAndPing(id: 9, domain: "dianping.com", ping: 0),
                           DomainAndPing(id: 10, domain: "zhihu.com", ping: 0),
                           DomainAndPing(id: 11, domain: "sogou.com", ping: 0),
                           DomainAndPing(id: 12, domain: "pinduoduo.com", ping: 0),
                        ]
        
}
