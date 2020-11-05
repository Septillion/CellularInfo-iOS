//
//  DetailedView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/3.
//

import SwiftUI

struct DetailedView: View {
    
    let networkInfo = NetworkInformation()
    @State var pingNumberAveraged : Double = 0
    @State var pingNumberDouble : [Double] = []
    @State var pingNumberCurrent: Double = 0
    
    var body: some View {
        
        
        
        VStack {
            
            Text("Disclaimer")
                .font(.title)
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Text("We do not collect any personal information. In fact, we don't collect any information at all. When you press the submit button, everything goes straight to Apple's CloudKit servers. We do not poccess any information that can be used to identify you.")
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Spacer()
            
            MapView()
                .frame(width: .infinity, height: 100)
                .cornerRadius(8)
            
            Group {
                Text(UIDevice().type.rawValue)
                    .font(.title)
                Text(networkInfo.carrierName + " " + networkInfo.radioAccessTech)
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
            
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("同意并提交")
                    .frame(minWidth: 100, maxWidth: .infinity, idealHeight: 48, alignment: .center)
                    .padding()
                    .background(Color(.systemBlue))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .font(.title)
            })
        }
        .padding()
        
    }
}

struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView()
    }
}


