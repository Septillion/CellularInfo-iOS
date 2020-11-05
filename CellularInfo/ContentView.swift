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
    
    let networkInfo = NetworkInformation()
    
    var body: some View {
        ZStack{
            InteractiveMapView()
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                
                HStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame( width: .infinity, height: 24, alignment: .topLeading)
                    
                    Spacer()
                }.padding()
                
                
                Spacer()
                
                VStack {
                    Group {
                        Text(UIDevice().type.rawValue)
                            .font(.title)
                        Text("活跃：" + networkInfo.carrierName + " " + networkInfo.radioAccessTech)
                        Text("当前延迟：\(Int(pingNumberCurrent))ms (平均：\(Int(pingNumberAveraged))ms)")
                            .onAppear(perform: {
                                OperationQueue().addOperation {
                                    for _ in 1...1000000
                                    {
                                        OperationQueue.main.addOperation {
                                            PlainPing.ping("www.qq.com", withTimeout: 10.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
                                                if let latency = timeElapsed {
                                                    print("latency (ms): \(latency)")
                                                    pingNumberCurrent = latency
                                                    pingNumberDouble.append(latency)
                                                    let pingNumberCombined = pingNumberDouble.reduce(0,+)
                                                    pingNumberAveraged = pingNumberCombined/Double(pingNumberDouble.count)
                                                }
                                                if let error = error {
                                                    print("error: \(error.localizedDescription)")
                                                }
                                            })
                                        }
                                        sleep(1)
                                        
                                    }
                                }
                            })
                    }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
                }.padding(.horizontal)
                
                
                Button(action: {
                    self.showSheetView = true
                }, label: {
                    Text("提交")
                        .frame(minWidth: 100, maxWidth: .infinity, idealHeight: 48, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                        .background(Color(.systemBlue))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
                        .padding(.bottom, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }).sheet(isPresented: $showSheetView, content: {
                    DetailedView(pingNumberAveraged: pingNumberAveraged)
                })
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone 12").previewDisplayName("iPhone 12")
            ContentView().previewDevice("iPad Pro (9.7-inch)").previewDisplayName("iPad Pro")
        }
    }
}

