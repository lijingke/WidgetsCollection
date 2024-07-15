//
//  Log.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/15.
//

import Foundation

enum Log {
    enum LogLevel {
        case info
        case warning
        case error

        fileprivate var prefix: String {
            switch self {
            case .info: return "ℹ️ INFO"
            case .warning: return "⚠️ WARN"
            case .error: return "🛑 ERROR"
            }
        }
    }

    struct Context {
        let file: String
        let function: String
        let line: Int

        var description: String {
            return "------------------------------------------------\n→ File: \((file as NSString).lastPathComponent):\(line) \n→ Function: \(function)\n"
        }
    }

    static func info(_ descriptionString: String?, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)

        Log.handleLog(level: .info, outputString: descriptionString ?? "nil", context: context)
    }

    static func warning(_ descriptionString: String, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)

        Log.handleLog(level: .warning, outputString: descriptionString, context: context)
    }

    static func error(_ descriptionString: String, file: String = #file, function: String = #function, line: Int = #line) {
        let context = Context(file: file, function: function, line: line)

        Log.handleLog(level: .error, outputString: descriptionString, context: context)
    }

    fileprivate static func handleLog(level: LogLevel, outputString: String, context: Context) {
        let logComponents = ["[\(level.prefix)]", outputString]
        #if DEBUG
            print(logComponents.joined(separator: "\n") + "\n" + "\(context.description)")
        #endif
    }
}
