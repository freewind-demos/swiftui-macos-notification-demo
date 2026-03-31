import SwiftUI

// 定义通知名称
extension Notification.Name {
    static let didUpdateData = Notification.Name("didUpdateData")
    static let didLogin = Notification.Name("didLogin")
    static let showDetail = Notification.Name("showDetail")
}

// 数据模型
struct NotificationData {
    let id: Int
    let message: String
}

struct ContentView: View {
    @State private var notificationCount = 0
    @State private var lastNotification = "无"
    @State private var showDetail = false

    var body: some View {
        Form {
            Section("发送通知") {
                Button("发送更新通知") {
                    sendNotification()
                }

                Button("发送登录通知") {
                    NotificationCenter.default.post(
                        name: .didLogin,
                        object: "用户123"
                    )
                    lastNotification = "didLogin"
                }

                Button("显示详情 (带数据)") {
                    NotificationCenter.default.post(
                        name: .showDetail,
                        object: NotificationData(id: 1, message: "详情消息")
                    )
                }
            }

            Section("通知历史") {
                Text("收到通知: \(lastNotification)")
                    .foregroundColor(.secondary)

                Text("通知计数: \(notificationCount)")
                    .foregroundColor(.secondary)
            }

            Section("监听详情") {
                if showDetail {
                    Text("详情面板已打开")
                        .foregroundColor(.blue)
                } else {
                    Text("点击按钮打开详情")
                        .foregroundColor(.secondary)
                }
            }

            Section("使用说明") {
                Text("这个 Demo 演示了 SwiftUI 中使用 NotificationCenter 进行视图间通信")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("通知机制适合解耦的组件通信")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .formStyle(.grouped)
        .padding()
        .onAppear {
            setupNotifications()
        }
    }

    func setupNotifications() {
        // 监听数据更新通知
        NotificationCenter.default.addObserver(
            forName: .didUpdateData,
            object: nil,
            queue: .main
        ) { _ in
            notificationCount += 1
            lastNotification = "didUpdateData"
        }

        // 监听登录通知
        NotificationCenter.default.addObserver(
            forName: .didLogin,
            object: nil,
            queue: .main
        ) { notification in
            notificationCount += 1
            let username = notification.object as? String ?? "未知"
            lastNotification = "didLogin (\(username))"
        }

        // 监听详情显示（带数据）
        NotificationCenter.default.addObserver(
            forName: .showDetail,
            object: nil,
            queue: .main
        ) { notification in
            notificationCount += 1
            if let data = notification.object as? NotificationData {
                lastNotification = "showDetail (id: \(data.id))"
                showDetail = true

                // 3秒后自动关闭
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showDetail = false
                }
            }
        }
    }

    func sendNotification() {
        NotificationCenter.default.post(
            name: .didUpdateData,
            object: nil
        )
    }
}
