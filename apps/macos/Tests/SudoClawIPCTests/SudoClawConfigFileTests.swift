import Foundation
import Testing
@testable import SudoClaw

@Suite(.serialized)
struct SudoClawConfigFileTests {
    @Test
    func configPathRespectsEnvOverride() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("sudoclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("sudoclaw.json")
            .path

        await TestIsolation.withEnvValues(["SUDOCLAW_CONFIG_PATH": override]) {
            #expect(SudoClawConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("sudoclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("sudoclaw.json")
            .path

        await TestIsolation.withEnvValues(["SUDOCLAW_CONFIG_PATH": override]) {
            SudoClawConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(SudoClawConfigFile.remoteGatewayPort() == 19999)
            #expect(SudoClawConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(SudoClawConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(SudoClawConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("sudoclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("sudoclaw.json")
            .path

        await TestIsolation.withEnvValues(["SUDOCLAW_CONFIG_PATH": override]) {
            SudoClawConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            SudoClawConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = SudoClawConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @MainActor
    @Test
    func clearRemoteGatewayUrlRemovesOnlyUrlField() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("sudoclaw-config-\(UUID().uuidString)")
            .appendingPathComponent("sudoclaw.json")
            .path

        await TestIsolation.withEnvValues(["SUDOCLAW_CONFIG_PATH": override]) {
            SudoClawConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                        "token": "tok",
                    ],
                ],
            ])
            SudoClawConfigFile.clearRemoteGatewayUrl()
            let root = SudoClawConfigFile.loadDict()
            let remote = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any]) ?? [:]
            #expect((remote["url"] as? String) == nil)
            #expect((remote["token"] as? String) == "tok")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("sudoclaw-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "SUDOCLAW_CONFIG_PATH": nil,
            "SUDOCLAW_STATE_DIR": dir,
        ]) {
            #expect(SudoClawConfigFile.stateDirURL().path == dir)
            #expect(SudoClawConfigFile.url().path == "\(dir)/sudoclaw.json")
        }
    }

    @MainActor
    @Test
    func saveDictAppendsConfigAuditLog() async throws {
        let stateDir = FileManager().temporaryDirectory
            .appendingPathComponent("sudoclaw-state-\(UUID().uuidString)", isDirectory: true)
        let configPath = stateDir.appendingPathComponent("sudoclaw.json")
        let auditPath = stateDir.appendingPathComponent("logs/config-audit.jsonl")

        defer { try? FileManager().removeItem(at: stateDir) }

        try await TestIsolation.withEnvValues([
            "SUDOCLAW_STATE_DIR": stateDir.path,
            "SUDOCLAW_CONFIG_PATH": configPath.path,
        ]) {
            SudoClawConfigFile.saveDict([
                "gateway": ["mode": "local"],
            ])

            let configData = try Data(contentsOf: configPath)
            let configRoot = try JSONSerialization.jsonObject(with: configData) as? [String: Any]
            #expect((configRoot?["meta"] as? [String: Any]) != nil)

            let rawAudit = try String(contentsOf: auditPath, encoding: .utf8)
            let lines = rawAudit
                .split(whereSeparator: \.isNewline)
                .map(String.init)
            #expect(!lines.isEmpty)
            guard let last = lines.last else {
                Issue.record("Missing config audit line")
                return
            }
            let auditRoot = try JSONSerialization.jsonObject(with: Data(last.utf8)) as? [String: Any]
            #expect(auditRoot?["source"] as? String == "macos-sudoclaw-config-file")
            #expect(auditRoot?["event"] as? String == "config.write")
            #expect(auditRoot?["result"] as? String == "success")
            #expect(auditRoot?["configPath"] as? String == configPath.path)
        }
    }
}
