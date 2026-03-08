package ai.sudoclaw.android.protocol

import org.junit.Assert.assertEquals
import org.junit.Test

class SudoClawProtocolConstantsTest {
  @Test
  fun canvasCommandsUseStableStrings() {
    assertEquals("canvas.present", SudoClawCanvasCommand.Present.rawValue)
    assertEquals("canvas.hide", SudoClawCanvasCommand.Hide.rawValue)
    assertEquals("canvas.navigate", SudoClawCanvasCommand.Navigate.rawValue)
    assertEquals("canvas.eval", SudoClawCanvasCommand.Eval.rawValue)
    assertEquals("canvas.snapshot", SudoClawCanvasCommand.Snapshot.rawValue)
  }

  @Test
  fun a2uiCommandsUseStableStrings() {
    assertEquals("canvas.a2ui.push", SudoClawCanvasA2UICommand.Push.rawValue)
    assertEquals("canvas.a2ui.pushJSONL", SudoClawCanvasA2UICommand.PushJSONL.rawValue)
    assertEquals("canvas.a2ui.reset", SudoClawCanvasA2UICommand.Reset.rawValue)
  }

  @Test
  fun capabilitiesUseStableStrings() {
    assertEquals("canvas", SudoClawCapability.Canvas.rawValue)
    assertEquals("camera", SudoClawCapability.Camera.rawValue)
    assertEquals("screen", SudoClawCapability.Screen.rawValue)
    assertEquals("voiceWake", SudoClawCapability.VoiceWake.rawValue)
    assertEquals("location", SudoClawCapability.Location.rawValue)
    assertEquals("sms", SudoClawCapability.Sms.rawValue)
    assertEquals("device", SudoClawCapability.Device.rawValue)
    assertEquals("notifications", SudoClawCapability.Notifications.rawValue)
    assertEquals("system", SudoClawCapability.System.rawValue)
    assertEquals("appUpdate", SudoClawCapability.AppUpdate.rawValue)
    assertEquals("photos", SudoClawCapability.Photos.rawValue)
    assertEquals("contacts", SudoClawCapability.Contacts.rawValue)
    assertEquals("calendar", SudoClawCapability.Calendar.rawValue)
    assertEquals("motion", SudoClawCapability.Motion.rawValue)
  }

  @Test
  fun cameraCommandsUseStableStrings() {
    assertEquals("camera.list", SudoClawCameraCommand.List.rawValue)
    assertEquals("camera.snap", SudoClawCameraCommand.Snap.rawValue)
    assertEquals("camera.clip", SudoClawCameraCommand.Clip.rawValue)
  }

  @Test
  fun screenCommandsUseStableStrings() {
    assertEquals("screen.record", SudoClawScreenCommand.Record.rawValue)
  }

  @Test
  fun notificationsCommandsUseStableStrings() {
    assertEquals("notifications.list", SudoClawNotificationsCommand.List.rawValue)
    assertEquals("notifications.actions", SudoClawNotificationsCommand.Actions.rawValue)
  }

  @Test
  fun deviceCommandsUseStableStrings() {
    assertEquals("device.status", SudoClawDeviceCommand.Status.rawValue)
    assertEquals("device.info", SudoClawDeviceCommand.Info.rawValue)
    assertEquals("device.permissions", SudoClawDeviceCommand.Permissions.rawValue)
    assertEquals("device.health", SudoClawDeviceCommand.Health.rawValue)
  }

  @Test
  fun systemCommandsUseStableStrings() {
    assertEquals("system.notify", SudoClawSystemCommand.Notify.rawValue)
  }

  @Test
  fun photosCommandsUseStableStrings() {
    assertEquals("photos.latest", SudoClawPhotosCommand.Latest.rawValue)
  }

  @Test
  fun contactsCommandsUseStableStrings() {
    assertEquals("contacts.search", SudoClawContactsCommand.Search.rawValue)
    assertEquals("contacts.add", SudoClawContactsCommand.Add.rawValue)
  }

  @Test
  fun calendarCommandsUseStableStrings() {
    assertEquals("calendar.events", SudoClawCalendarCommand.Events.rawValue)
    assertEquals("calendar.add", SudoClawCalendarCommand.Add.rawValue)
  }

  @Test
  fun motionCommandsUseStableStrings() {
    assertEquals("motion.activity", SudoClawMotionCommand.Activity.rawValue)
    assertEquals("motion.pedometer", SudoClawMotionCommand.Pedometer.rawValue)
  }
}
