import Cocoa
import FlutterMacOS
import os

@main
class AppDelegate: FlutterAppDelegate {
    var processPid: Int32? = nil

    override func applicationDidFinishLaunching(_ notification: Notification) {
        let logger = Logger(subsystem: "com.pcrady.fife_image", category: "server")

        let serverExecutablePath = Bundle.main.path(forResource: "main", ofType: nil)
        guard let serverPath = serverExecutablePath else {
            logger.info("Server executable not found")
            return
        }

        let workingDirectory = "\(NSHomeDirectory())/FifeImage/"

        do {
            try FileManager.default.createDirectory(
                atPath: workingDirectory,
                withIntermediateDirectories: true,
                attributes: nil)
            logger.info("Directory created or already exists at: \(workingDirectory)")
        } catch {
            logger.error("Failed to create directory: \(error)")
        }

        let logFileURL = URL(fileURLWithPath: "\(workingDirectory)/flask_server.log")

        if !FileManager.default.fileExists(atPath: logFileURL.path) {
            FileManager.default.createFile(atPath: logFileURL.path, contents: nil, attributes: nil)
        }

        let fileHandle = try? FileHandle(forWritingTo: logFileURL)

        let process = Process()
        process.currentDirectoryURL = URL(fileURLWithPath: workingDirectory)
        process.executableURL = URL(fileURLWithPath: serverPath)
        process.arguments = []
        process.standardOutput = fileHandle
        process.standardError = fileHandle

        do {
            try process.run()
            self.processPid = process.processIdentifier
            logger.info("Server started with PID: \(self.processPid!)")
        } catch {
            logger.error("Failed to start server: \(error)")
        }

        super.applicationDidFinishLaunching(notification)
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationWillTerminate(_ notification: Notification) {
        let logger = Logger(subsystem: "com.pcrady.fife_image", category: "server")

        if let pid = self.processPid {
            kill(pid, SIGTERM)
            logger.info("Server process terminated: \(self.processPid!)")
        }
        super.applicationWillTerminate(notification)
    }
}
