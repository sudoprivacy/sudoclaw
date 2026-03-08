import Foundation

public enum SudoClawCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum SudoClawCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum SudoClawCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum SudoClawCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct SudoClawCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: SudoClawCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: SudoClawCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: SudoClawCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: SudoClawCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct SudoClawCameraClipParams: Codable, Sendable, Equatable {
    public var facing: SudoClawCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: SudoClawCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: SudoClawCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: SudoClawCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
