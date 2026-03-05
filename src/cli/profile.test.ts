import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "sudoclaw",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "sudoclaw", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "sudoclaw", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "sudoclaw", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "sudoclaw", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "sudoclaw", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "sudoclaw", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it.each([
    ["--dev first", ["node", "sudoclaw", "--dev", "--profile", "work", "status"]],
    ["--profile first", ["node", "sudoclaw", "--profile", "work", "--dev", "status"]],
  ])("rejects combining --dev with --profile (%s)", (_name, argv) => {
    const res = parseCliProfileArgs(argv);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join(path.resolve("/home/peter"), ".openclaw-dev");
    expect(env.SUDOCLAW_PROFILE).toBe("dev");
    expect(env.SUDOCLAW_STATE_DIR).toBe(expectedStateDir);
    expect(env.SUDOCLAW_CONFIG_PATH).toBe(path.join(expectedStateDir, "sudoclaw.json"));
    expect(env.SUDOCLAW_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      SUDOCLAW_STATE_DIR: "/custom",
      SUDOCLAW_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.SUDOCLAW_STATE_DIR).toBe("/custom");
    expect(env.SUDOCLAW_GATEWAY_PORT).toBe("19099");
    expect(env.SUDOCLAW_CONFIG_PATH).toBe(path.join("/custom", "sudoclaw.json"));
  });

  it("uses SUDOCLAW_HOME when deriving profile state dir", () => {
    const env: Record<string, string | undefined> = {
      SUDOCLAW_HOME: "/srv/sudoclaw-home",
      HOME: "/home/other",
    };
    applyCliProfileEnv({
      profile: "work",
      env,
      homedir: () => "/home/fallback",
    });

    const resolvedHome = path.resolve("/srv/sudoclaw-home");
    expect(env.SUDOCLAW_STATE_DIR).toBe(path.join(resolvedHome, ".openclaw-work"));
    expect(env.SUDOCLAW_CONFIG_PATH).toBe(
      path.join(resolvedHome, ".openclaw-work", "sudoclaw.json"),
    );
  });
});

describe("formatCliCommand", () => {
  it.each([
    {
      name: "no profile is set",
      cmd: "sudoclaw doctor --fix",
      env: {},
      expected: "sudoclaw doctor --fix",
    },
    {
      name: "profile is default",
      cmd: "sudoclaw doctor --fix",
      env: { SUDOCLAW_PROFILE: "default" },
      expected: "sudoclaw doctor --fix",
    },
    {
      name: "profile is Default (case-insensitive)",
      cmd: "sudoclaw doctor --fix",
      env: { SUDOCLAW_PROFILE: "Default" },
      expected: "sudoclaw doctor --fix",
    },
    {
      name: "profile is invalid",
      cmd: "sudoclaw doctor --fix",
      env: { SUDOCLAW_PROFILE: "bad profile" },
      expected: "sudoclaw doctor --fix",
    },
    {
      name: "--profile is already present",
      cmd: "sudoclaw --profile work doctor --fix",
      env: { SUDOCLAW_PROFILE: "work" },
      expected: "sudoclaw --profile work doctor --fix",
    },
    {
      name: "--dev is already present",
      cmd: "sudoclaw --dev doctor",
      env: { SUDOCLAW_PROFILE: "dev" },
      expected: "sudoclaw --dev doctor",
    },
  ])("returns command unchanged when $name", ({ cmd, env, expected }) => {
    expect(formatCliCommand(cmd, env)).toBe(expected);
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("sudoclaw doctor --fix", { SUDOCLAW_PROFILE: "work" })).toBe(
      "sudoclaw --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("sudoclaw doctor --fix", { SUDOCLAW_PROFILE: "  jbopenclaw  " })).toBe(
      "sudoclaw --profile jbsudoclaw doctor --fix",
    );
  });

  it("handles command with no args after openclaw", () => {
    expect(formatCliCommand("sudoclaw", { SUDOCLAW_PROFILE: "test" })).toBe(
      "sudoclaw --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm sudoclaw doctor", { SUDOCLAW_PROFILE: "work" })).toBe(
      "pnpm sudoclaw --profile work doctor",
    );
  });
});
