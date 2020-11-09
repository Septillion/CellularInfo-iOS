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
    @State var pingNumberAveraged : Double = 0
    @State var pingNumberDouble : [Double] = []
    @State var pingNumberCurrent: Double = 0
    @State var StartButtonEnabled : Bool = true
    
    @ObservedObject var domainAndPing = AGroupOfDomainsAndPings()
    
    let networkInfo = CellularAndWifiInformation()
    
    var body: some View {
        
        VStack{
            
            List {
                VStack(alignment: .leading) {
                    Text(UIDevice().type.rawValue).font(.title)
                    Text("活跃：" + networkInfo.carrierName + " " + networkInfo.radioAccessTech)
                }
                
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
            
            Spacer()
            
            VStack {
                Group {
                    
                    Text("平均：\(Int(pingNumberAveraged))ms")
                        .onAppear(perform: {
                            
                        })
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
            }.padding(.horizontal)
            
            
            Button(action: {
                StartButtonEnabled = false
                
                // Clear the View
                for i in 0...(domainAndPing.count-1)
                {
                    self.domainAndPing.daps[i].setPing(ping:0)
                }
                
                
                
                /*
                DispatchQueue.main.async {
                    for i in 0...(domainAndPing.count-1)
                    {
                        var currentLatency : [Double] = []
                        PlainPing.ping(domainAndPing.daps[i].domain, withTimeout: 10.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
                            if let latency = timeElapsed {
                                print("latency (ms): \(latency)")
                                currentLatency.append(latency)
                                self.domainAndPing.daps[i].setPing(ping: latency )
                            }
                            if let error = error {
                                print("error: \(error.localizedDescription)")
                            }
                        })
                        usleep(500000)
                    }
                    StartButtonEnabled = true
                }
                 */
                
                /*
                //Ping
                OperationQueue().addOperation {
                    for i in 0...(domainAndPing.count-1)
                    {
                        var currentLatency : [Double] = []
                        OperationQueue.main.addOperation {
                            
                            StartButtonEnabled = false
                            
                            PlainPing.ping(domainAndPing.daps[i].domain, withTimeout: 10.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
                                if let latency = timeElapsed {
                                    print("latency (ms): \(latency)")
                                    currentLatency.append(latency)
                                    self.domainAndPing.daps[i].setPing(ping: latency )
                                }
                                if let error = error {
                                    print("error: \(error.localizedDescription)")
                                }
                            })
                        }
                        usleep(1000000)
                        StartButtonEnabled = true
                    }
                }
                 */
                
                self.pingNext()
                
            }, label: {
                Text("开始测试")
                    .frame(minWidth: 100, maxWidth: .infinity, idealHeight: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding()
                    .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            })
            .disabled(!StartButtonEnabled)
            .sheet(isPresented: $showSheetView, content: {
                DetailedView(showSheetView: self.$showSheetView, pingNumberAveraged: pingNumberAveraged)
            })
        }
    }
    
    func pingNext() {
        
        guard domainAndPing.daps.count > 0 else{
            return
        }
        
        let ping = domainAndPing.daps.removeFirst().domain
        PlainPing.ping(ping,withTimeout: 1.0, completionBlock: {
            (timeElapsed:Double?, error:Error?) in
                    if let latency = timeElapsed {
                        print("\(ping) latency (ms): \(latency)")
                    }
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    self.pingNext()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone 12").previewDisplayName("iPhone 12")
        }
    }
}

