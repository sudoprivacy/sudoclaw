import Foundation

public enum SudoClawChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(SudoClawChatEventPayload)
    case agent(SudoClawAgentEventPayload)
    case seqGap
}

public protocol SudoClawChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> SudoClawChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [SudoClawChatAttachmentPayload]) async throws -> SudoClawChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> SudoClawChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<SudoClawChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension SudoClawChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "SudoClawChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> SudoClawChatSessionsListResponse {
        throw NSError(
            domain: "SudoClawChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
