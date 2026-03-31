# SwiftUI macOS NotificationCenter 通知机制

## 简介

演示 SwiftUI 中使用 NotificationCenter 进行视图间通信和解耦。

## 快速开始

```bash
cd swiftui-macos-notification-demo
xcodegen generate
open SwiftUINotificationDemo.xcodeproj
# Cmd+R 运行
```

## 概念讲解

### 定义通知名称

```swift
extension Notification.Name {
    static let didUpdateData = Notification.Name("didUpdateData")
}
```

### 发送通知

```swift
NotificationCenter.default.post(
    name: .didUpdateData,
    object: nil  // 可选的数据
)
```

### 带数据发送

```swift
NotificationCenter.default.post(
    name: .didLogin,
    object: "用户名"  // 传递数据
)
```

### 监听通知

```swift
NotificationCenter.default.addObserver(
    forName: .didUpdateData,
    object: nil,
    queue: .main
) { notification in
    // 处理通知
}
```

## 完整示例

```swift
// 定义通知
extension Notification.Name {
    static let dataChanged = Notification.Name("dataChanged")
}

// 发送方
Button("更新") {
    NotificationCenter.default.post(
        name: .dataChanged,
        object: nil
    )
}

// 接收方
.onAppear {
    NotificationCenter.default.addObserver(
        forName: .dataChanged,
        object: nil,
        queue: .main
    ) { _ in
        refreshData()
    }
}
```

## 完整讲解（中文）

### NotificationCenter vs 状态传递

| 方式 | NotificationCenter | @State/@EnvironmentObject |
|------|-------------------|--------------------------|
| 耦合度 | 低 | 高 |
| 适合距离 | 任意层级 | 父子/祖先 |
| 性能 | 一般 | 好 |
| 数据传递 | 支持 | 直接绑定 |

### 使用场景

- 跨层通信（如从网络层通知 UI）
- 解耦组件
- 系统事件通知

### 注意事项

1. 不需要时记得移除监听
2. 使用 `.onAppear` 添加，`.onDisappear` 移除
3. 通知是同步的，频繁发送可能影响性能
