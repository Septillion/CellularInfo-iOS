//
//  ContentView.swift
//  FView Cellular Info
//
//  Created by 王跃琨 on 2020/11/2.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    @State var showSheetView = false
    @State var pingNumberDouble : [Double] = []
    @State var StartButtonEnabled : Bool = true
    @State var SubmitButtonEnabled : Bool = false
    @State var currentArrayIndex: Int = 0
    @State var averagePing = DomainAndPing(id: 10086, domain: "平均", ping: 0)
    @State var currentNetwork : String = ""
    @State var pingButtonString = "Ping!"
    @State var isTestDoneOnWifi: Bool = false
    let hapticsGenerator = UISelectionFeedbackGenerator()
    let hapticsGeneratorHeavy = UIImpactFeedbackGenerator(style: .heavy)
    
    @ObservedObject var domainAndPing = AGroupOfDomainsAndPings()
    
    var body: some View {
        
        VStack{
            
            //Header
            HStack {
                VStack(alignment: .leading) {
                    Text(UIDevice().type.rawValue).font(.title)
                    Text(currentNetwork)
                        .onAppear(perform: {
                            getCurrentNetwork()
                        })
                }
                Spacer()
                
                //MARK: Ping! Button
                Button(action: {
                    // Clear the View
                    averagePing.setPing(ping: 0)
                    for i in 0...(domainAndPing.count-1)
                    {
                        self.domainAndPing.daps[i].setPing(ping:0)
                    }
                    hapticsGenerator.prepare()
                    pingNumberDouble.removeAll()
                    StartButtonEnabled = false
                    pingButtonString = "Pinging..."
                    SubmitButtonEnabled = false
                    getCurrentNetwork()
                    self.pingNext()
                    
                }, label: {
                    HStack {
                        Image(systemName:"play.fill")
                        Text(pingButtonString)
                    }
                    .frame(minWidth: 80, maxWidth: 100, idealHeight: 48, alignment: .center)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(8)
                    .foregroundColor(.white)
                    .font(.body)
                    .shadow(radius: 4)
                })
                .disabled(!StartButtonEnabled)
                
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            //List
            List {
                
                ForEach(domainAndPing.daps){ mDomainAndPing in
                    //PingListItem(DomainAndping: mDomainAndPing)
                    HStack {
                        Text(mDomainAndPing.domain)
                        Spacer()
                        Text(mDomainAndPing.latencyString)
                            .foregroundColor(mDomainAndPing.latencyColor)
                    }
                }
                
                // MARK: Average Result at the Bottom
                VStack {
                    HStack {
                        Text("平均").font(.headline)
                        
                        //Submit Button
                        HStack {
                            Button(action: {
                                self.showSheetView = true
                                SubmitButtonEnabled = false
                            }, label: {
                                HStack {
                                    //Image(systemName: "square.and.arrow.up")
                                    Text("提交此结果")
                                }
                                .foregroundColor(Color.accentColor)
                                
                            })
                            .disabled(!SubmitButtonEnabled)
                            .sheet(isPresented: $showSheetView, content: {
                                DetailedView(showSheetView: self.$showSheetView, pingNumberAveraged: averagePing.ping, isTestDoneOnWifi: self.isTestDoneOnWifi)
                            })
                        }
                        
                        Spacer()
                        
                        Text(averagePing.latencyString)
                            .foregroundColor(averagePing.latencyColor)
                            .font(.headline)
                    }
                }
            }
            
            Spacer()
        }
    }
    
    func pingNext() {
        
        //MARK: Final Work
        guard domainAndPing.daps.count > currentArrayIndex else{
            currentArrayIndex = 0
            StartButtonEnabled = true
            SubmitButtonEnabled = true
            hapticsGeneratorHeavy.impactOccurred(intensity: 100)
            pingButtonString = "Ping!"
            if pingNumberDouble.count < domainAndPing.count {
                averagePing.setPing(ping: 999999)
                return
            }  
            averagePing.setPing(ping: (pingNumberDouble.reduce(0,+)/Double(pingNumberDouble.count)))
            return
        }
        
        //MARK: Ping
        let ping = domainAndPing.daps[currentArrayIndex].domain
        PlainPing.ping(ping, withTimeout: 2.0, completionBlock: {
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
    
    func getCurrentNetwork() {
        
        let networkInfo = CellularAndWifiInformation()
        currentNetwork = networkInfo.carrierName + " " + networkInfo.radioAccessTech
        isTestDoneOnWifi = false
        
        if networkInfo.isWiFiConnected{
            isTestDoneOnWifi = true
            currentNetwork = "WiFi: " + networkInfo.ssid!
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

