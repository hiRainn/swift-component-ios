//
//  TimeLine.swift
//  swift-component-ios
//
//  Created by heihei on 2024/1/5.
//

import SwiftUI

struct TimeLineView: View {
    @State private var dataList: [SomeData] = []

    var body: some View {
        VStack{
            TimeLineView()
        }
        .onAppear{
            onAppearEvent()
        }
    }

    @ViewBuilder
    func TimeLineView() -> some View {
        if self.dataList.count != 0 {
            ScrollViewReader { scrollViewProxy in
                ScrollView{
                    VStack(spacing:20) {
                        ForEach(self.dataList.indices,id:\.self) { index in
                            TimeLineItem(item:self.$dataList[index])
                                .background(alignment: .leading) {
                                    if dataList.last?.id != self.dataList[index].id {
                                        Rectangle()
                                            .frame(width: 1)
                                            .offset(x:8)
                                            .padding(.bottom,-20)
                                    }
                                }
                        }
                    }.padding([.top,.leading],20)

                }
                .hSpacing(.leading)
                .frame(maxHeight: 600)
                .background(Color(red: 248/255, green: 248/255, blue: 255/255),in: .rect(cornerRadius: 20))
                .padding(12)
            }
        } else {
            Text("no data")
        }
    }

    //timeline item
    struct TimeLineItem: View {
        //binding item to change data
        @Binding var item: SomeData
        var body: some View {
            HStack(alignment: .top,spacing: 15) {
                Circle()
                    .fill(item.isFinish ? .green : .blue)
                    .frame(width: 10,height: 10)
                    .padding(4)
                    .background(.white.shadow(.drop(color:.black.opacity(0.1),radius: 3)),in:.circle)
                    .overlay{
                        Circle()
                            .frame(width: 50,height: 50)
                            .blendMode(.destinationOver)
                            .onTapGesture() {
                                withAnimation(.snappy) {
                                    item.isFinish.toggle()
                                }
                            }
                    }

                VStack(alignment: .leading, spacing: 8,content: {
                    Text(item.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(item.isFinish ? .gray : .black)

                    Label(item.createAt.format("hh:mm a"),systemImage: "clock")
                        .font(.caption)
                        .foregroundColor(.black)
                })
                .padding(15)
                .hSpacing(.leading)
                .background(item.tagColor,in: .rect(topLeadingRadius: 15,bottomLeadingRadius: 15))
                .strikethrough(item.isFinish,pattern:.solid,color: .black)
                .offset(y:-8)
            }
            .hSpacing(.leading)
        }

    }



    

    func onAppearEvent() {
        initDataList()
        self.dataList = initTimeLineData()
    }

}

#Preview {
    TimeLineView()
}

