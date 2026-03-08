package ai.sudoclaw.android.node

import ai.sudoclaw.android.protocol.SudoClawCalendarCommand
import ai.sudoclaw.android.protocol.SudoClawCameraCommand
import ai.sudoclaw.android.protocol.SudoClawCapability
import ai.sudoclaw.android.protocol.SudoClawContactsCommand
import ai.sudoclaw.android.protocol.SudoClawDeviceCommand
import ai.sudoclaw.android.protocol.SudoClawLocationCommand
import ai.sudoclaw.android.protocol.SudoClawMotionCommand
import ai.sudoclaw.android.protocol.SudoClawNotificationsCommand
import ai.sudoclaw.android.protocol.SudoClawPhotosCommand
import ai.sudoclaw.android.protocol.SudoClawSmsCommand
import ai.sudoclaw.android.protocol.SudoClawSystemCommand
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class InvokeCommandRegistryTest {
  @Test
  fun advertisedCapabilities_respectsFeatureAvailability() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = false,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(capabilities.contains(SudoClawCapability.Canvas.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Screen.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Device.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Notifications.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.System.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.AppUpdate.rawValue))
    assertFalse(capabilities.contains(SudoClawCapability.Camera.rawValue))
    assertFalse(capabilities.contains(SudoClawCapability.Location.rawValue))
    assertFalse(capabilities.contains(SudoClawCapability.Sms.rawValue))
    assertFalse(capabilities.contains(SudoClawCapability.VoiceWake.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Photos.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Contacts.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Calendar.rawValue))
    assertFalse(capabilities.contains(SudoClawCapability.Motion.rawValue))
  }

  @Test
  fun advertisedCapabilities_includesFeatureCapabilitiesWhenEnabled() {
    val capabilities =
      InvokeCommandRegistry.advertisedCapabilities(
        NodeRuntimeFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          voiceWakeEnabled = true,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = false,
        ),
      )

    assertTrue(capabilities.contains(SudoClawCapability.Canvas.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Screen.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Device.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Notifications.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.System.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.AppUpdate.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Camera.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Location.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Sms.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.VoiceWake.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Photos.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Contacts.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Calendar.rawValue))
    assertTrue(capabilities.contains(SudoClawCapability.Motion.rawValue))
  }

  @Test
  fun advertisedCommands_respectsFeatureAvailability() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = false,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertFalse(commands.contains(SudoClawCameraCommand.Snap.rawValue))
    assertFalse(commands.contains(SudoClawCameraCommand.Clip.rawValue))
    assertFalse(commands.contains(SudoClawCameraCommand.List.rawValue))
    assertFalse(commands.contains(SudoClawLocationCommand.Get.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Status.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Info.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Permissions.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Health.rawValue))
    assertTrue(commands.contains(SudoClawNotificationsCommand.List.rawValue))
    assertTrue(commands.contains(SudoClawNotificationsCommand.Actions.rawValue))
    assertTrue(commands.contains(SudoClawSystemCommand.Notify.rawValue))
    assertTrue(commands.contains(SudoClawPhotosCommand.Latest.rawValue))
    assertTrue(commands.contains(SudoClawContactsCommand.Search.rawValue))
    assertTrue(commands.contains(SudoClawContactsCommand.Add.rawValue))
    assertTrue(commands.contains(SudoClawCalendarCommand.Events.rawValue))
    assertTrue(commands.contains(SudoClawCalendarCommand.Add.rawValue))
    assertFalse(commands.contains(SudoClawMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(SudoClawMotionCommand.Pedometer.rawValue))
    assertFalse(commands.contains(SudoClawSmsCommand.Send.rawValue))
    assertFalse(commands.contains("debug.logs"))
    assertFalse(commands.contains("debug.ed25519"))
    assertTrue(commands.contains("app.update"))
  }

  @Test
  fun advertisedCommands_includesFeatureCommandsWhenEnabled() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = true,
          locationEnabled = true,
          smsAvailable = true,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = true,
          debugBuild = true,
        ),
      )

    assertTrue(commands.contains(SudoClawCameraCommand.Snap.rawValue))
    assertTrue(commands.contains(SudoClawCameraCommand.Clip.rawValue))
    assertTrue(commands.contains(SudoClawCameraCommand.List.rawValue))
    assertTrue(commands.contains(SudoClawLocationCommand.Get.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Status.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Info.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Permissions.rawValue))
    assertTrue(commands.contains(SudoClawDeviceCommand.Health.rawValue))
    assertTrue(commands.contains(SudoClawNotificationsCommand.List.rawValue))
    assertTrue(commands.contains(SudoClawNotificationsCommand.Actions.rawValue))
    assertTrue(commands.contains(SudoClawSystemCommand.Notify.rawValue))
    assertTrue(commands.contains(SudoClawPhotosCommand.Latest.rawValue))
    assertTrue(commands.contains(SudoClawContactsCommand.Search.rawValue))
    assertTrue(commands.contains(SudoClawContactsCommand.Add.rawValue))
    assertTrue(commands.contains(SudoClawCalendarCommand.Events.rawValue))
    assertTrue(commands.contains(SudoClawCalendarCommand.Add.rawValue))
    assertTrue(commands.contains(SudoClawMotionCommand.Activity.rawValue))
    assertTrue(commands.contains(SudoClawMotionCommand.Pedometer.rawValue))
    assertTrue(commands.contains(SudoClawSmsCommand.Send.rawValue))
    assertTrue(commands.contains("debug.logs"))
    assertTrue(commands.contains("debug.ed25519"))
    assertTrue(commands.contains("app.update"))
  }

  @Test
  fun advertisedCommands_onlyIncludesSupportedMotionCommands() {
    val commands =
      InvokeCommandRegistry.advertisedCommands(
        NodeRuntimeFlags(
          cameraEnabled = false,
          locationEnabled = false,
          smsAvailable = false,
          voiceWakeEnabled = false,
          motionActivityAvailable = true,
          motionPedometerAvailable = false,
          debugBuild = false,
        ),
      )

    assertTrue(commands.contains(SudoClawMotionCommand.Activity.rawValue))
    assertFalse(commands.contains(SudoClawMotionCommand.Pedometer.rawValue))
  }
}
