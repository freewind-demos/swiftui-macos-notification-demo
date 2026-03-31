import Cocoa

@main
struct NotificationApp: App {
    var body: some Scene {
        Window("NotificationCenter 通知", id: "main") {
            ContentView()
        }
        .defaultSize(width: 500, height: 500)
    }
}
