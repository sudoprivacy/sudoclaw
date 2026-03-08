import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#sudoclaw",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#sudoclaw",
      rawTarget: "#sudoclaw",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "sudoclaw-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "sudoclaw-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "sudoclaw-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "sudoclaw-bot",
      rawTarget: "sudoclaw-bot",
    });
  });
});
