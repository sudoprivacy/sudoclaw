import Foundation

public enum SudoClawDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum SudoClawBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum SudoClawThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum SudoClawNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum SudoClawNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct SudoClawBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: SudoClawBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: SudoClawBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct SudoClawThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: SudoClawThermalState

    public init(state: SudoClawThermalState) {
        self.state = state
    }
}

public struct SudoClawStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct SudoClawNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: SudoClawNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [SudoClawNetworkInterfaceType]

    public init(
        status: SudoClawNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [SudoClawNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct SudoClawDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: SudoClawBatteryStatusPayload
    public var thermal: SudoClawThermalStatusPayload
    public var storage: SudoClawStorageStatusPayload
    public var network: SudoClawNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: SudoClawBatteryStatusPayload,
        thermal: SudoClawThermalStatusPayload,
        storage: SudoClawStorageStatusPayload,
        network: SudoClawNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct SudoClawDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
