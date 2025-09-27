//
//  ContentView.swift
//  FastReboot
//
//  Created by Mac on 2024/10/11.
//

import SwiftUI

struct ContentView: View {
    @State private var LogMessage = "一键重启"
    @State private var textColor = Color.black // 初始字体颜色为灰色
    private let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    var body: some View {
        VStack {
            Text(LogMessage)
                .multilineTextAlignment(.center)
                .foregroundColor(textColor) // 设置文本颜色
                .onAppear(){
                    LogMessage = "需要巨魔安装才能生效！\n当前版本：v\(version)\n开发者：肖博vlog"
                    // 延迟 0.5 秒改变字体颜色为白色
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        textColor = Color.white
                    }
                }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // 让 VStack 占据全屏
        .background(Color.black) // 整个页面背景设置为黑色
        .edgesIgnoringSafeArea(.all) // 让背景填充整个屏幕
        .onAppear(){
            // 延迟执行重启操作，避免白屏
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                do {
                    try RootHelper.reboot()
                } catch {
                    print("Error: " + error.localizedDescription)
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
