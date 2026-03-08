import CoreLocation
import Foundation
import SudoClawKit
import UIKit

typealias SudoClawCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias SudoClawCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: SudoClawCameraSnapParams) async throws -> SudoClawCameraSnapResult
    func clip(params: SudoClawCameraClipParams) async throws -> SudoClawCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: SudoClawLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: SudoClawLocationGetParams,
        desiredAccuracy: SudoClawLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: SudoClawLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> SudoClawDeviceStatusPayload
    func info() -> SudoClawDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: SudoClawPhotosLatestParams) async throws -> SudoClawPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: SudoClawContactsSearchParams) async throws -> SudoClawContactsSearchPayload
    func add(params: SudoClawContactsAddParams) async throws -> SudoClawContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: SudoClawCalendarEventsParams) async throws -> SudoClawCalendarEventsPayload
    func add(params: SudoClawCalendarAddParams) async throws -> SudoClawCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: SudoClawRemindersListParams) async throws -> SudoClawRemindersListPayload
    func add(params: SudoClawRemindersAddParams) async throws -> SudoClawRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: SudoClawMotionActivityParams) async throws -> SudoClawMotionActivityPayload
    func pedometer(params: SudoClawPedometerParams) async throws -> SudoClawPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: SudoClawWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
