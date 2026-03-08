import Foundation

// Stable identifier used for both the macOS LaunchAgent label and Nix-managed defaults suite.
// nix-sudoclaw writes app defaults into this suite to survive app bundle identifier churn.
let launchdLabel = "ai.sudoclaw.mac"
let gatewayLaunchdLabel = "ai.sudoclaw.gateway"
let onboardingVersionKey = "sudoclaw.onboardingVersion"
let onboardingSeenKey = "sudoclaw.onboardingSeen"
let currentOnboardingVersion = 7
let pauseDefaultsKey = "sudoclaw.pauseEnabled"
let iconAnimationsEnabledKey = "sudoclaw.iconAnimationsEnabled"
let swabbleEnabledKey = "sudoclaw.swabbleEnabled"
let swabbleTriggersKey = "sudoclaw.swabbleTriggers"
let voiceWakeTriggerChimeKey = "sudoclaw.voiceWakeTriggerChime"
let voiceWakeSendChimeKey = "sudoclaw.voiceWakeSendChime"
let showDockIconKey = "sudoclaw.showDockIcon"
let defaultVoiceWakeTriggers = ["sudoclaw"]
let voiceWakeMaxWords = 32
let voiceWakeMaxWordLength = 64
let voiceWakeMicKey = "sudoclaw.voiceWakeMicID"
let voiceWakeMicNameKey = "sudoclaw.voiceWakeMicName"
let voiceWakeLocaleKey = "sudoclaw.voiceWakeLocaleID"
let voiceWakeAdditionalLocalesKey = "sudoclaw.voiceWakeAdditionalLocaleIDs"
let voicePushToTalkEnabledKey = "sudoclaw.voicePushToTalkEnabled"
let talkEnabledKey = "sudoclaw.talkEnabled"
let iconOverrideKey = "sudoclaw.iconOverride"
let connectionModeKey = "sudoclaw.connectionMode"
let remoteTargetKey = "sudoclaw.remoteTarget"
let remoteIdentityKey = "sudoclaw.remoteIdentity"
let remoteProjectRootKey = "sudoclaw.remoteProjectRoot"
let remoteCliPathKey = "sudoclaw.remoteCliPath"
let canvasEnabledKey = "sudoclaw.canvasEnabled"
let cameraEnabledKey = "sudoclaw.cameraEnabled"
let systemRunPolicyKey = "sudoclaw.systemRunPolicy"
let systemRunAllowlistKey = "sudoclaw.systemRunAllowlist"
let systemRunEnabledKey = "sudoclaw.systemRunEnabled"
let locationModeKey = "sudoclaw.locationMode"
let locationPreciseKey = "sudoclaw.locationPreciseEnabled"
let peekabooBridgeEnabledKey = "sudoclaw.peekabooBridgeEnabled"
let deepLinkKeyKey = "sudoclaw.deepLinkKey"
let modelCatalogPathKey = "sudoclaw.modelCatalogPath"
let modelCatalogReloadKey = "sudoclaw.modelCatalogReload"
let cliInstallPromptedVersionKey = "sudoclaw.cliInstallPromptedVersion"
let heartbeatsEnabledKey = "sudoclaw.heartbeatsEnabled"
let debugPaneEnabledKey = "sudoclaw.debugPaneEnabled"
let debugFileLogEnabledKey = "sudoclaw.debug.fileLogEnabled"
let appLogLevelKey = "sudoclaw.debug.appLogLevel"
let voiceWakeSupported: Bool = ProcessInfo.processInfo.operatingSystemVersion.majorVersion >= 26
