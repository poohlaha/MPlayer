// 监听网络请求

import Network

class NetworkManager {
    
    let monitor = NWPathMonitor()
    var isNetworkPermissionRequested: Bool = false
    
    // 自定义初始化方法
   func setup(completion: @escaping (Int) -> Void) {
       // 检查网络权限是否已经请求
       if isNetworkPermissionRequested {
           // 网络权限已请求，执行网络初始化
           performNetworkSetup(completion: completion)
       } else {
           // 网络权限未请求，请求网络权限
           completion(0)
       }
   }

   func performNetworkSetup(completion: @escaping (Int) -> Void) {
        monitor.pathUpdateHandler = { path in
            var result = 0


            if path.status == .satisfied {
                print("网络已连接")
                if path.usesInterfaceType(.wifi) {
                    print("已连接到 Wi-Fi")
                    result = 1
                } else {
                    print("连接到其他网络")
                    result = 2
                }
            } else {
                print("无网络连接")
                result = 0
            }

            if path.isExpensive {
                print("使用了代价较高的连接（如蜂窝数据）")
                result = 3
            }

            // 在闭包中调用传递进来的 completion，将结果传递给调用方
            completion(result)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
