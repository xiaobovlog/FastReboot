//
//  RootHelper.swift
//  FastReboot
//
//  Created by Mac on 2024/10/12.
//
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

class RootHelper {
    static let rootHelperPath = Bundle.main.url(forAuxiliaryExecutable: "ipccroothelper")?.path ?? "/"
    
    static func reboot() throws  {
        let code = spawnRoot(rootHelperPath, ["", "", ""], nil, nil)
        guard code == 0 else { throw "Helper.Reboot: returned non-zero code \(code)" }
    }
}
