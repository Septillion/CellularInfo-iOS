//
//  AutoModeView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/23.
//

import SwiftUI

struct AutoModeView: View {
    
    @ObservedObject var locationManager = LocationManager()
    @ObservedObject var domainAndPing = AGroupOfDomainsAndPings()
    let hapticsGeneratorHeavy = UINotificationFeedbackGenerator()
    
    //State of UI
    @Binding var showAutoModeViewSheet: Bool
    @State var isToggleOn: Bool = false
    @State var showAlert: Bool = false
    @State var currentNetwork : String = ""
    @State var alertMessage: String = ""
    
    //State of Testing
    @State var isThereAlreadyAPing: Bool = false
    @State var isTestDoneOnWifi: Bool = false
    @State var isTestDoneOnVPN: Bool = false
    @State var currentArrayIndex: Int = 0
    
    //Data of Testing
    @State var mobileCarrier: String = ""
    @State var radioAccessTech: String = ""
    @State var coordinateAsOfTesting: CLLocationCoordinate2D?
    @State var averagePing = DomainAndPing(id: 10086, domain: "平均", ping: 0)
    
    //Temporary Data
    @State var sumOfPingLatencySoFar: Double = 0
    
    //MARK: - View Body
    var body: some View {
        NavigationView{
            
            VStack (alignment: .leading, spacing: 15) {
                
                ZStack{
                      
                        AutoModeMapView()
                            .cornerRadius(16)
                        //.shadow(radius: 3 )
                                  
                    HStack {
                        VStack (alignment: .leading) {
                            
                            Text(UIDevice().type.rawValue)
                                .font(.title)
                            Text(currentNetwork)
                            Text("\(averagePing.latencyString)")
                                .foregroundColor(averagePing.latencyColor)
                            
                            Spacer()
                            
                        }
                        .onAppear(perform: {
                            getCurrentNetwork()
                        })
                        Spacer()
                    }
                    .padding()
                    
                }
                .frame(maxHeight: 200)
                
                //Divider()
                
                Toggle(isOn: $isToggleOn, label: {
                    Text("开始边走边测")
                })
                .onReceive([self.isToggleOn].publisher.first(), perform: { _ in
                    if isToggleOn {
                        startAutomaticPing()
                    }
                })
                .alert(isPresented: $showAlert, content: {
                    Alert(title: Text("请等一下！"), message: Text(alertMessage), dismissButton: .default(Text("关闭")))
                })
                
                Text("持续测试并提交结果。为保证准确性，在自动模式开启时缓慢移动，避免使用快速交通工具（例如摩托车、汽车、高铁、千年隼，或 TARDIS)。")
                    .frame( maxWidth: .infinity, alignment: .leading)
                    .font(.footnote)
                
                
                //Divider()
                
                Spacer()
                
                Text("我们非常重视您的隐私，仅上述显示信息会被提交。本 app 基于 CloudKit 构建，我们不设任何中转服务器用于接受或处理信息。您可访问 github.com/Septillion/CellularInfo-iOS 查阅原始代码。")
                    .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
                
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
    
    //MARK: - This function exists to prevent multiple ping threads from being created
    func startAutomaticPing(){
        
        guard isThereAlreadyAPing == false else {
            //print("ping already started, refuse")
            return
        }
        
        isThereAlreadyAPing = true
        PingTheCrapOutOfIt()
    }
    
    //MARK: - Ping the Whole List
    func PingTheCrapOutOfIt(){
        
        //Check if meets requirements
        getCurrentNetwork()
        
        //Abort when: Toggle is off, sheet dismissed
        guard isToggleOn == true
                && showAutoModeViewSheet == true
                
        else{
            print("stopped")
            isThereAlreadyAPing = false
            isToggleOn = false
            averagePing.setPing(ping: 0)
            
            //Turn Off Auto Lock
            UIApplication.shared.isIdleTimerDisabled = false
            
            return
        }
        
        //Abort when: (TODO: Move too slow, Move too fast), not on Cellular, Location Permission not granted
        // TODO: Location Permission
        guard isTestDoneOnVPN == false
                && isTestDoneOnWifi == false
                && mobileCarrier != ""
        else {
            self.alertMessage = "请确认：WiFi 关闭、VPN 关闭、蜂窝网络已连接"
            showAlert = true
            
            print("stopped")
            isThereAlreadyAPing = false
            isToggleOn = false
            averagePing.setPing(ping: 0)
            
            return
        }
        
        // MARK: - Start a new Group, some preperation work
        
        //Aquire current location
        coordinateAsOfTesting = locationManager.lastLocation?.coordinate
        
        //Clear State variables
        for i in 0...(domainAndPing.daps.count-1)
        {
            self.domainAndPing.daps[i].setPing(ping:0)
        }
        sumOfPingLatencySoFar = 0
        
        //Turn Off Auto Lock
        UIApplication.shared.isIdleTimerDisabled = true
        
        pingNext()
        
    }
    
    //MARK: - Ping One Domain
    
    func pingNext(){
        
        // Gets called each time a group of ping is finished
        guard domainAndPing.daps.count > currentArrayIndex else{
            
            // Clear State Variables
            currentArrayIndex = 0
            
            // Find out Average
            if sumOfPingLatencySoFar >= 999999{
                averagePing.setPing(ping: 999999)
            } else {
                averagePing.setPing(ping: sumOfPingLatencySoFar / Double(domainAndPing.daps.count))
            }
            print (averagePing.latencyString)
            
            // Upload to CloudKit
            let dataReadyForUpload = FinalDataStructure(AveragedPingLatency: averagePing.ping,
                                                        DeviceName: UIDevice().type.rawValue,
                                                        Location: coordinateAsOfTesting!,
                                                        MobileCarrier: mobileCarrier,
                                                        RadioAccessTechnology: radioAccessTech)
            let cloudKitmanager = CloudRelatedStuff.CloudKitManager()
            cloudKitmanager.PushData(finalData: [dataReadyForUpload], completionHandler: {_,_ in
                print("Data Uploaded")
                return
            })
            
            // Celebrate finish
            hapticsGeneratorHeavy.notificationOccurred(.success)
            
            // HOLD UP A SEC!
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // Start the Next round
                PingTheCrapOutOfIt()
            }
            
            return
        }
        
        // Ping Work
        let ping = domainAndPing.daps[currentArrayIndex].domain
        PlainPing.ping(ping, withTimeout: 1.0, completionBlock: {
            (timeElapsed:Double?, error:Error?) in
            
            if let latency = timeElapsed {
                //print("\(ping) latency (ms): \(latency)")
                self.sumOfPingLatencySoFar += latency
            }
            if let error = error {
                self.sumOfPingLatencySoFar += 999999
                print("error: \(error.localizedDescription)")
            }
            currentArrayIndex += 1
            self.pingNext()
            
        })
        
    }
    
    
    //MARK: - Check WiFi and Cellular and VPN
    func getCurrentNetwork() {
        
        let networkInfo = CellularAndWifiInformation()
        mobileCarrier = networkInfo.carrierName
        radioAccessTech = networkInfo.radioAccessTech
        currentNetwork = mobileCarrier + " " + radioAccessTech
        
        isTestDoneOnWifi = false
        
        if networkInfo.isWiFiConnected{
            isTestDoneOnWifi = true
            currentNetwork = "WiFi: " + networkInfo.ssid!
        }
        
        if networkInfo.isConnectedToVpn {
            isTestDoneOnVPN = true
            currentNetwork = "已连接到 VPN"
        }else {
            isTestDoneOnVPN = false
        }
    }
    
}

struct AutoModeView_Previews: PreviewProvider {
    static var previews: some View {
        AutoModeView(showAutoModeViewSheet: .constant(true))
    }
}
