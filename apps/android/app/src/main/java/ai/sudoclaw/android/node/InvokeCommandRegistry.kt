package ai.sudoclaw.android.node

import ai.sudoclaw.android.protocol.SudoClawCalendarCommand
import ai.sudoclaw.android.protocol.SudoClawCanvasA2UICommand
import ai.sudoclaw.android.protocol.SudoClawCanvasCommand
import ai.sudoclaw.android.protocol.SudoClawCameraCommand
import ai.sudoclaw.android.protocol.SudoClawCapability
import ai.sudoclaw.android.protocol.SudoClawContactsCommand
import ai.sudoclaw.android.protocol.SudoClawDeviceCommand
import ai.sudoclaw.android.protocol.SudoClawLocationCommand
import ai.sudoclaw.android.protocol.SudoClawMotionCommand
import ai.sudoclaw.android.protocol.SudoClawNotificationsCommand
import ai.sudoclaw.android.protocol.SudoClawPhotosCommand
import ai.sudoclaw.android.protocol.SudoClawScreenCommand
import ai.sudoclaw.android.protocol.SudoClawSmsCommand
import ai.sudoclaw.android.protocol.SudoClawSystemCommand

data class NodeRuntimeFlags(
  val cameraEnabled: Boolean,
  val locationEnabled: Boolean,
  val smsAvailable: Boolean,
  val voiceWakeEnabled: Boolean,
  val motionActivityAvailable: Boolean,
  val motionPedometerAvailable: Boolean,
  val debugBuild: Boolean,
)

enum class InvokeCommandAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  MotionActivityAvailable,
  MotionPedometerAvailable,
  DebugBuild,
}

enum class NodeCapabilityAvailability {
  Always,
  CameraEnabled,
  LocationEnabled,
  SmsAvailable,
  VoiceWakeEnabled,
  MotionAvailable,
}

data class NodeCapabilitySpec(
  val name: String,
  val availability: NodeCapabilityAvailability = NodeCapabilityAvailability.Always,
)

data class InvokeCommandSpec(
  val name: String,
  val requiresForeground: Boolean = false,
  val availability: InvokeCommandAvailability = InvokeCommandAvailability.Always,
)

object InvokeCommandRegistry {
  val capabilityManifest: List<NodeCapabilitySpec> =
    listOf(
      NodeCapabilitySpec(name = SudoClawCapability.Canvas.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.Screen.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.Device.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.Notifications.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.System.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.AppUpdate.rawValue),
      NodeCapabilitySpec(
        name = SudoClawCapability.Camera.rawValue,
        availability = NodeCapabilityAvailability.CameraEnabled,
      ),
      NodeCapabilitySpec(
        name = SudoClawCapability.Sms.rawValue,
        availability = NodeCapabilityAvailability.SmsAvailable,
      ),
      NodeCapabilitySpec(
        name = SudoClawCapability.VoiceWake.rawValue,
        availability = NodeCapabilityAvailability.VoiceWakeEnabled,
      ),
      NodeCapabilitySpec(
        name = SudoClawCapability.Location.rawValue,
        availability = NodeCapabilityAvailability.LocationEnabled,
      ),
      NodeCapabilitySpec(name = SudoClawCapability.Photos.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.Contacts.rawValue),
      NodeCapabilitySpec(name = SudoClawCapability.Calendar.rawValue),
      NodeCapabilitySpec(
        name = SudoClawCapability.Motion.rawValue,
        availability = NodeCapabilityAvailability.MotionAvailable,
      ),
    )

  val all: List<InvokeCommandSpec> =
    listOf(
      InvokeCommandSpec(
        name = SudoClawCanvasCommand.Present.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasCommand.Hide.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasCommand.Navigate.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasCommand.Eval.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasCommand.Snapshot.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasA2UICommand.Push.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasA2UICommand.PushJSONL.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawCanvasA2UICommand.Reset.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawScreenCommand.Record.rawValue,
        requiresForeground = true,
      ),
      InvokeCommandSpec(
        name = SudoClawSystemCommand.Notify.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawCameraCommand.List.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = SudoClawCameraCommand.Snap.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = SudoClawCameraCommand.Clip.rawValue,
        requiresForeground = true,
        availability = InvokeCommandAvailability.CameraEnabled,
      ),
      InvokeCommandSpec(
        name = SudoClawLocationCommand.Get.rawValue,
        availability = InvokeCommandAvailability.LocationEnabled,
      ),
      InvokeCommandSpec(
        name = SudoClawDeviceCommand.Status.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawDeviceCommand.Info.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawDeviceCommand.Permissions.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawDeviceCommand.Health.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawNotificationsCommand.List.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawNotificationsCommand.Actions.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawPhotosCommand.Latest.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawContactsCommand.Search.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawContactsCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawCalendarCommand.Events.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawCalendarCommand.Add.rawValue,
      ),
      InvokeCommandSpec(
        name = SudoClawMotionCommand.Activity.rawValue,
        availability = InvokeCommandAvailability.MotionActivityAvailable,
      ),
      InvokeCommandSpec(
        name = SudoClawMotionCommand.Pedometer.rawValue,
        availability = InvokeCommandAvailability.MotionPedometerAvailable,
      ),
      InvokeCommandSpec(
        name = SudoClawSmsCommand.Send.rawValue,
        availability = InvokeCommandAvailability.SmsAvailable,
      ),
      InvokeCommandSpec(
        name = "debug.logs",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(
        name = "debug.ed25519",
        availability = InvokeCommandAvailability.DebugBuild,
      ),
      InvokeCommandSpec(name = "app.update"),
    )

  private val byNameInternal: Map<String, InvokeCommandSpec> = all.associateBy { it.name }

  fun find(command: String): InvokeCommandSpec? = byNameInternal[command]

  fun advertisedCapabilities(flags: NodeRuntimeFlags): List<String> {
    return capabilityManifest
      .filter { spec ->
        when (spec.availability) {
          NodeCapabilityAvailability.Always -> true
          NodeCapabilityAvailability.CameraEnabled -> flags.cameraEnabled
          NodeCapabilityAvailability.LocationEnabled -> flags.locationEnabled
          NodeCapabilityAvailability.SmsAvailable -> flags.smsAvailable
          NodeCapabilityAvailability.VoiceWakeEnabled -> flags.voiceWakeEnabled
          NodeCapabilityAvailability.MotionAvailable -> flags.motionActivityAvailable || flags.motionPedometerAvailable
        }
      }
      .map { it.name }
  }

  fun advertisedCommands(flags: NodeRuntimeFlags): List<String> {
    return all
      .filter { spec ->
        when (spec.availability) {
          InvokeCommandAvailability.Always -> true
          InvokeCommandAvailability.CameraEnabled -> flags.cameraEnabled
          InvokeCommandAvailability.LocationEnabled -> flags.locationEnabled
          InvokeCommandAvailability.SmsAvailable -> flags.smsAvailable
          InvokeCommandAvailability.MotionActivityAvailable -> flags.motionActivityAvailable
          InvokeCommandAvailability.MotionPedometerAvailable -> flags.motionPedometerAvailable
          InvokeCommandAvailability.DebugBuild -> flags.debugBuild
        }
      }
      .map { it.name }
  }
}
