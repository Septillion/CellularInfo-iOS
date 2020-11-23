//
//  ContentView.swift
//  FView Cellular Info
//
//  Created by 王跃琨 on 2020/11/2.
//

import SwiftUI
//import CoreLocation

//MARK: The first page of the app that handles the Ping! functionality.
struct ContentView: View {
    
    @ObservedObject var locationManager = LocationManager()
    
    @State var showDetailedViewSheet = false
    @State var showAutoModeViewSheet = false
    @State var showAlert: Bool = false
    @State var pingNumberDouble : [Double] = []
    @State var StartButtonEnabled : Bool = true
    @State var SubmitButtonEnabled : Bool = false
    @State var currentArrayIndex: Int = 0
    @State var averagePing = DomainAndPing(id: 10086, domain: "平均", ping: 0)
    @State var currentNetwork : String = ""
    @State var mobileCarrier: String = ""
    @State var radioAccessTech: String = ""
    @State var pingButtonString = "Ping!"
    @State var submitButtonString = "提交此结果"
    @State var alertMessage: String = ""
    @State var isTestDoneOnWifi: Bool = false
    @State var isTestDoneOnVPN: Bool = false
    @State var coordinateAsOfTesting: CLLocationCoordinate2D?
    let hapticsGenerator = UISelectionFeedbackGenerator()
    let hapticsGeneratorHeavy = UIImpactFeedbackGenerator(style: .heavy)
    let hapticsGeneratorNotifications = UINotificationFeedbackGenerator()
    
    @ObservedObject var domainAndPing = AGroupOfDomainsAndPings()
    
    var body: some View {
        
        VStack (spacing: 0){
            
            
            //MARK: - List
            List {
                
                // Header
                Section {
                    
                    VStack(alignment: .leading) {
                        Text(UIDevice().type.rawValue).font(.title)
                        Text(currentNetwork)
                            .font(.caption)
                            .onAppear(perform: {
                                getCurrentNetwork()
                            })
                    }
                    
                    Button(action: {
                        
                        //Aquire current location
                        //let locationManager = LocationManager()
                        coordinateAsOfTesting = locationManager.lastLocation?.coordinate
                        
                        // Clear the View
                        averagePing.setPing(ping: 0)
                        for i in 0...(domainAndPing.daps.count-1)
                        {
                            self.domainAndPing.daps[i].setPing(ping:0)
                        }
                        hapticsGenerator.prepare()
                        pingNumberDouble.removeAll()
                        StartButtonEnabled = false
                        pingButtonString = "Pinging..."
                        //self.submitButtonString = ""
                        SubmitButtonEnabled = false
                        getCurrentNetwork()
                        
                        self.pingNext()
                        
                        
                        
                        
                    }, label: {
                        HStack {
                            Image(systemName:"play.fill")
                            Text(pingButtonString)
                                .font(.headline)
                        }
                        //.frame(minWidth: 80, maxWidth: 100, idealHeight: 48, alignment: .center)
                        //.padding()
                        //.background(Color.accentColor)
                        //.cornerRadius(8)
                        //.foregroundColor(.white)
                        //.font(.body)
                        //.shadow(color: .accentColor, radius: 3, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    })
                    .disabled(!StartButtonEnabled)
                    
                }
                
                Section{
                    ForEach(domainAndPing.daps){ mDomainAndPing in
                        //PingListItem(DomainAndping: mDomainAndPing)
                        HStack {
                            Text(mDomainAndPing.domain)
                            Spacer()
                            Text(mDomainAndPing.latencyString)
                                .foregroundColor(mDomainAndPing.latencyColor)
                        }
                    }
                    
                }
                
                
                // MARK: - Average Result at the Bottom
                Section {
                    
                    VStack {
                        HStack {
                            Text("平均").font(.headline)
                            
                            Spacer()
                            
                            //MARK: - Submit Button
                            
                            Text(averagePing.latencyString)
                                .foregroundColor(averagePing.latencyColor)
                                .font(.headline)
                        }
                    }
                    
                    if SubmitButtonEnabled{
                        
                        Button(action: {
                            
                            if isTestDoneOnVPN{
                                self.alertMessage = "不可以上传基于 VPN 的测试结果，此结果可能不准确。"
                                hapticsGeneratorNotifications.notificationOccurred(.warning)
                                showAlert = true
                                return
                            }
                            
                            
                            if isTestDoneOnWifi{
                                self.alertMessage = "不可以上传基于 WiFi 的测试结果，我们只接受使用蜂窝网络进行的测试。"
                                hapticsGeneratorNotifications.notificationOccurred(.warning)
                                showAlert = true
                                return
                            }
                            
                            
                            if coordinateAsOfTesting == nil {
                                self.alertMessage = "无法获取位置，我们只接受位置有效的测试。"
                                hapticsGeneratorNotifications.notificationOccurred(.warning)
                                showAlert = true
                                return
                            }
                            
                            if mobileCarrier == "" {
                                self.alertMessage = "蜂窝网络未连接，我们只接受使用蜂窝网络进行的测试。"
                                hapticsGeneratorNotifications.notificationOccurred(.warning)
                                showAlert = true
                                return
                            }
                            
                            if averagePing.ping == 0 {
                                self.alertMessage = "网络中断"
                                hapticsGeneratorNotifications.notificationOccurred(.warning)
                                showAlert = true
                                return
                            }
                            
                            
                            self.showDetailedViewSheet = true
                            SubmitButtonEnabled = false
                        }, label: {
                            HStack {
                                Spacer()
                                Image(systemName: "square.and.arrow.up")
                                Text(self.submitButtonString)
                            }
                            .foregroundColor(Color.accentColor)
                            
                        })
                        .disabled(!SubmitButtonEnabled)
                        .sheet(isPresented: $showDetailedViewSheet, content: {
                            DetailedView(showSheetView: self.$showDetailedViewSheet, dataReadyForUpload: FinalDataStructure(AveragedPingLatency: averagePing.ping, DeviceName:UIDevice().type.rawValue , Location: coordinateAsOfTesting!, MobileCarrier: mobileCarrier, RadioAccessTechnology: radioAccessTech))
                        })
                        .alert(isPresented: $showAlert, content: {
                            Alert(title: Text("请等一下！"), message: Text(alertMessage), dismissButton: .default(Text("关闭")))
                        })
                    }
                    
                    
                    
                }
                
                // MARK: - AutoMode Button
                
                Section (footer: Text("持续测试并提交结果，适合边走边测")) {
                    Button(action: {
                        self.showAutoModeViewSheet = true
                    }, label: {
                        Text("边走边测")
                    })
                    .sheet(isPresented: $showAutoModeViewSheet, content: {
                        AutoModeView(showAutoModeViewSheet: $showAutoModeViewSheet)
                    })
                }
                
            }
            .listStyle(GroupedListStyle())
        }
    }
    
    func pingNext() {
        
        //MARK: - Final Work
        guard domainAndPing.daps.count > currentArrayIndex else{
            currentArrayIndex = 0
            StartButtonEnabled = true
            SubmitButtonEnabled = true
            hapticsGeneratorHeavy.impactOccurred(intensity: 100)
            pingButtonString = "Ping!"
            //self.submitButtonString = "提交此结果"
            // if one of the pings didn't come through
            if pingNumberDouble.count < domainAndPing.daps.count {
                averagePing.setPing(ping: 999999)
                return
            }
            // Otherwise
            averagePing.setPing(ping: (pingNumberDouble.reduce(0,+)/Double(pingNumberDouble.count)))
            return
        }
        
        //MARK: - Ping
        
        let ping = domainAndPing.daps[currentArrayIndex].domain
        PlainPing.ping(ping, withTimeout: 4.0, completionBlock: {
            (timeElapsed:Double?, error:Error?) in
            
            if let latency = timeElapsed {
                print("\(ping) latency (ms): \(latency)")
                self.domainAndPing.daps[currentArrayIndex].setPing(ping: latency)
                self.pingNumberDouble.append(latency)
            }
            if let error = error {
                self.domainAndPing.daps[currentArrayIndex].setPing(ping: 999999)
                //self.pingNumberDouble.append(999999)
                print("error: \(error.localizedDescription)")
            }
            currentArrayIndex += 1
            hapticsGenerator.selectionChanged()
            self.pingNext()
            
            
            
        })
    }
    
    //MARK: -
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone 12").previewDisplayName("iPhone 12")
        }
    }
}

