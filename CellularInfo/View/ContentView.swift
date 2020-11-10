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
    let hapticsGenerator = UIImpactFeedbackGenerator()
    
    @ObservedObject var domainAndPing = AGroupOfDomainsAndPings()
    
    //let networkInfo = CellularAndWifiInformation()
    
    var body: some View {
        
        VStack{
            
            //Heaader
            HStack {
                VStack(alignment: .leading) {
                    Text(UIDevice().type.rawValue).font(.title)
                    Text(currentNetwork)
                        .onAppear(perform: {
                            getCurrentNetwork()
                        })
                }
                Spacer()
                Button(action: {
                    
                    // Clear the View
                    averagePing.setPing(ping: 0)
                    for i in 0...(domainAndPing.count-1)
                    {
                        self.domainAndPing.daps[i].setPing(ping:0)
                    }
                    StartButtonEnabled = false
                    SubmitButtonEnabled = false
                    getCurrentNetwork()
                    self.pingNext()
                    
                }, label: {
                    HStack {
                        Image(systemName:"play.fill")
                        Text("Ping!")
                    }
                    .frame(minWidth: 80, maxWidth: 100, idealHeight: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .font(.body)
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
                
                // Average Result at the Bottom
                VStack {
                    HStack {
                        Text("平均").font(.headline)
          
                        //Submit Button
                        HStack {
                            Button(action: {
                                self.showSheetView = true
                            }, label: {
                                HStack {
                                    //Image(systemName: "square.and.arrow.up")
                                    Text("提交此结果")
                                }
                                .foregroundColor(Color.accentColor)
                                
                            })
                            .disabled(!SubmitButtonEnabled)
                            .sheet(isPresented: $showSheetView, content: {
                                DetailedView(showSheetView: self.$showSheetView, pingNumberAveraged: averagePing.ping)
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
        
        guard domainAndPing.daps.count > currentArrayIndex else{
            currentArrayIndex = 0
            StartButtonEnabled = true
            SubmitButtonEnabled = true
            averagePing.setPing(ping: (pingNumberDouble.reduce(0,+)/Double(pingNumberDouble.count)))
            hapticsGenerator.impactOccurred()
            return
        }
        
        let ping = domainAndPing.daps[currentArrayIndex].domain
        PlainPing.ping(ping,withTimeout: 1.0, completionBlock: {
            (timeElapsed:Double?, error:Error?) in
                    if let latency = timeElapsed {
                        print("\(ping) latency (ms): \(latency)")
                        self.domainAndPing.daps[currentArrayIndex].setPing(ping: latency)
                        self.pingNumberDouble.append(latency)
                    }
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    currentArrayIndex += 1
                    self.pingNext()
        })
    }
    
    func getCurrentNetwork() {
        let networkInfo = CellularAndWifiInformation()
        currentNetwork = networkInfo.carrierName + " " + networkInfo.radioAccessTech
        if networkInfo.isWiFiConnected{
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

