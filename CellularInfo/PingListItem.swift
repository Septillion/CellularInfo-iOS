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
    }
}

class AGroupOfDomainsAndPings : ObservableObject {
    
    @Published var daps: [DomainAndPing]
    var count : Int
    
    init() {
        self.daps = [DomainAndPing(id: 1, domain: "qq.com", ping: 0),
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
                     DomainAndPing(id: 12, domain: "sspai.com", ping: 0),]
        
        self.count = 12
    }
}

/*
struct PingListItem: View {
    
    var DomainAndping: DomainAndPing
    
    @State var latencyString: String = ""
    @State var latencyColor = Color(.label)
    
    var body: some View {
        HStack {
            Text(DomainAndping.domain)
            Spacer()
            Text(latencyString)
                .foregroundColor(latencyColor)
                .onAppear(perform: {
                    if DomainAndping.ping < 100 {
                        latencyColor = Color(.systemGreen)
                    }
                    if (DomainAndping.ping >= 100)&&( DomainAndping.ping < 200) {
                        latencyColor = Color(.systemOrange)
                    }
                    if DomainAndping.ping >= 200 {
                        latencyColor = Color(.systemRed)
                    }
                    latencyString = "\(String(format: "%.1f", DomainAndping.ping))ms"
                    
                    if DomainAndping.ping == 0 {
                        latencyString = ""
                    }
                })
        }
    }
}

struct PingListItem_Previews: PreviewProvider {
    static var previews: some View {
        PingListItem(DomainAndping: DomainAndPing(id: 1, domain: "qq.com", ping: 0))
            .previewLayout(.fixed(width: 414, height: 70))
    }
}
*/
