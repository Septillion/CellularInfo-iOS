//
//  AutoModeView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/23.
//

import SwiftUI

struct AutoModeView: View {
    
    @Binding var showAutoModeViewSheet: Bool
    @State var isToggleOn: Bool = false
    @State var pingStarted: Bool = false
    
    @ObservedObject var domainAndPing = AGroupOfDomainsAndPings()
    
    let hapticsGeneratorHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    //MARK: - View Body
    var body: some View {
        NavigationView{
            
            VStack (alignment: .leading, spacing: 15) {
                
                Toggle(isOn: $isToggleOn, label: {
                    Text("开始边走边测")
                })
                .onReceive([self.isToggleOn].publisher.first(), perform: { _ in
                    if isToggleOn {
                        
                        startAutomaticPing()
                        
                    }else{
                    }
                })
                
                Text("持续测试并提交结果。为保证准确性，在自动模式开启时缓慢移动，避免使用快速交通工具（例如摩托车、汽车、高铁、千年隼，或 TARDIS。")
                    .frame( maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                
                Divider()
                
                Text("中国联通 LTE")
                
                AutoModeMapView()
                    .cornerRadius(16)
                    //.shadow(radius: 3 )
                
                Divider()
                
                Text("我们非常重视您的隐私，仅上述显示信息会被提交。本 app 基于 CloudKit 构建，我们不设任何中转服务器用于接受或处理信息。您可访问 github.com/Septillion/CellularInfo-iOS 查阅原始代码。")
                    .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .font(.footnote)
                
            }
            .padding()
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showAutoModeViewSheet = false
            }) {
                Text("关闭").bold()
            })
            
        }
        
    }
    
    func startAutomaticPing(){
        
        guard !pingStarted else {
            return
        }
        
        sleep(1)
        
        DispatchQueue.global().async {
            PingTheCrapOutOfIt()
        }
        pingStarted = true
        
    }
    
    //MARK: - Automatic Ping
    func PingTheCrapOutOfIt(){
        
        //Abort when: Toggle is off, Move too slow, Move too fast, sheet dismissed
        guard isToggleOn == true
                && showAutoModeViewSheet == true
        else{
            print("stopped")
            pingStarted = false
            return
        }
        
        // Variables to hold temperary data
        var pingNumbers: [Double] = []
        var averagePing: Double = 0
        
        // ping all sites
        for i in 0...(domainAndPing.daps.count - 1){
            
            PlainPing.ping( domainAndPing.daps[i].domain, withTimeout: 4.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
                
                if let latency = timeElapsed{
                    pingNumbers.append(latency)
                    print(latency)
                }
                if let error = error{
                    averagePing = 999999
                    print("error: \(error.localizedDescription), abort")
                    return
                }
            })
            
        }
        
        // Find Average
        if averagePing != 999999{
            averagePing = pingNumbers.reduce(0,+) / Double(pingNumbers.count)
            print(" Result Valid \(averagePing)")
        }else {
            print("an error occured")
        }
        
        //Upload
        
        hapticsGeneratorHeavy.impactOccurred(intensity: 100)
        sleep(1)
        PingTheCrapOutOfIt()
        
    }
    
}

struct AutoModeView_Previews: PreviewProvider {
    static var previews: some View {
        AutoModeView(showAutoModeViewSheet: .constant(true))
    }
}
