//
//  InsightListItem.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/20.
//

import SwiftUI

struct InsightListItem: View {
    
    var name: String
    var value: String
    var BarLengthPercent: CGFloat
    
    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 3) {
                HStack {
                    Text(name)
                    Spacer()
                    Text(value)
                }
                GeometryReader { metrics in
                    Rectangle()
                        .frame(width: max(BarLengthPercent * metrics.size.width, 1), height: 20)
                        .foregroundColor(.accentColor)
                }.frame(height: 20)
            }
        }
    }
}

struct InsightListItem_Previews: PreviewProvider {
    static var previews: some View {
        InsightListItem(name: "Aloha", value: "172.0", BarLengthPercent: 0.5)
    }
}
