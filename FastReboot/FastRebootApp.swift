//
//  FastRebootApp.swift
//  FastReboot
//
//  Created by Mac on 2024/10/11.
//

import SwiftUI
import CommonCrypto

@main
struct FastRebootApp: App {
    init() {
        print("Made by xiaobovlog")

        if (checkBundleID()&&checkAppName()&&checkAppIcon()&&checkBundleFileHash()){
            // 这里调用会出现短暂白屏，效果不好
//            do {
//                try RootHelper.reboot()
//            } catch {
//                print("Error"+error.localizedDescription)
//            }
        }
        else{
            exit(0)
        }

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func checkBundleID() -> Bool {
        let requiredPrefix = "com.xiaobovlog.FastReboot"

        if let bundleID = Bundle.main.bundleIdentifier {
            if bundleID.hasPrefix(requiredPrefix) {
                print("Bundle ID 验证成功")
                return true
            } else {
                print("Bundle ID 验证失败")
                return false
            }
        } else {
            print("无法打开应用")
            return false
        }
    }


    func checkAppName() -> Bool {
        let expectedAppName = "一键重启"

        if let infoDict = Bundle.main.infoDictionary,
           let appName = infoDict["CFBundleDisplayName"] as? String {

            if appName == expectedAppName {
//                print("应用名称验证成功")
                return true
            } else {
//                print("应用名称验证失败")
                return false
            }
        } else {
//            print("无法获取应用名称")
            return false
        }
    }


    func checkAppIcon() -> Bool {
        if let infoDict = Bundle.main.infoDictionary,
           infoDict["CFBundleIconFiles"] != nil {
            // 如果 Info.plist 中包含 "CFBundleIconFiles" 键，则返回 false
            return false
        }
        if let infoDict = Bundle.main.infoDictionary {
            if let iconsDict = infoDict["CFBundleIcons"] as? [String: Any],
               let primaryIconDict = iconsDict["CFBundlePrimaryIcon"] as? [String: Any],
               let iconFiles = primaryIconDict["CFBundleIconFiles"] as? [String],
               let appIconName = iconFiles.first {
                // 这里的 appIconName 就是应用图标的名称
                print("应用图标名称：\(appIconName)")
                if appIconName != "AppIcon60x60"{
                    return false
                }
            } else {
                //print("无法获取应用图标名称")
                return false
            }
        } else {
            //print("无法获取 Info.plist 数据")
            return false
        }
        return true
    }


    func checkBundleFileHash() -> Bool {
        var fileHashDictionary = [String: String]()

        if let resourcePath = Bundle.main.resourcePath,
           let fileArr = try? FileManager.default.contentsOfDirectory(atPath: resourcePath) {
            let fileNames = ["AppIcon60x60@2x.png", "AppIcon76x76@2x~ipad.png"]
            let hashStrings = ["18124d7f6cf8962c7cb1c6877e00db4e", "ff503117fd54c58ef0c51ec5d6d3b940"]
            let count = min(fileNames.count, hashStrings.count)
            for i in 0..<count {
                // 循环体
                let filePath = (resourcePath as NSString).appendingPathComponent(fileNames[i])
                if let hashString = calculateMD5(for: filePath) {
                    if hashString != (hashStrings[i])
                    {
//                        print("Hash 不匹配")
                        return false
                    }
                }
                else{
                    // 文件不存在
//                    print("文件不存在")
                    return false
                }
            }
        }
        // Logo Hash校验成功
//        print("Logo Hash校验成功")
        return true
    }

    func calculateMD5(for filePath: String) -> String? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
            var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            
            data.withUnsafeBytes { bytes in
                _ = CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
            }
            
            return digest.map { String(format: "%02hhx", $0) }.joined()
        } catch {
//            print("无法读取文件：\(filePath)")
            return nil
        }
    }


}
