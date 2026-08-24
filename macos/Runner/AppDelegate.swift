import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  // Đóng cửa sổ chỉ ẩn đi — app sống tiếp ở menu bar để đồng hồ pomodoro
  // vẫn chạy. Thoát hẳn bằng menu "Thoát" trên menu bar.
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return false
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
