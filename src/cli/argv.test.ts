import { describe, expect, it } from "vitest";
import {
  buildParseArgv,
  getFlagValue,
  getCommandPath,
  getPrimaryCommand,
  getPositiveIntFlagValue,
  getVerboseFlag,
  hasHelpOrVersion,
  hasFlag,
  isRootHelpInvocation,
  isRootVersionInvocation,
  shouldMigrateState,
  shouldMigrateStateFromPath,
} from "./argv.js";

describe("argv helpers", () => {
  it.each([
    {
      name: "help flag",
      argv: ["node", "sudoclaw", "--help"],
      expected: true,
    },
    {
      name: "version flag",
      argv: ["node", "sudoclaw", "-V"],
      expected: true,
    },
    {
      name: "normal command",
      argv: ["node", "sudoclaw", "status"],
      expected: false,
    },
    {
      name: "root -v alias",
      argv: ["node", "sudoclaw", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with profile",
      argv: ["node", "sudoclaw", "--profile", "work", "-v"],
      expected: true,
    },
    {
      name: "root -v alias with log-level",
      argv: ["node", "sudoclaw", "--log-level", "debug", "-v"],
      expected: true,
    },
    {
      name: "subcommand -v should not be treated as version",
      argv: ["node", "sudoclaw", "acp", "-v"],
      expected: false,
    },
    {
      name: "root -v alias with equals profile",
      argv: ["node", "sudoclaw", "--profile=work", "-v"],
      expected: true,
    },
    {
      name: "subcommand path after global root flags should not be treated as version",
      argv: ["node", "sudoclaw", "--dev", "skills", "list", "-v"],
      expected: false,
    },
  ])("detects help/version flags: $name", ({ argv, expected }) => {
    expect(hasHelpOrVersion(argv)).toBe(expected);
  });

  it.each([
    {
      name: "root --version",
      argv: ["node", "sudoclaw", "--version"],
      expected: true,
    },
    {
      name: "root -V",
      argv: ["node", "sudoclaw", "-V"],
      expected: true,
    },
    {
      name: "root -v alias with profile",
      argv: ["node", "sudoclaw", "--profile", "work", "-v"],
      expected: true,
    },
    {
      name: "subcommand version flag",
      argv: ["node", "sudoclaw", "status", "--version"],
      expected: false,
    },
    {
      name: "unknown root flag with version",
      argv: ["node", "sudoclaw", "--unknown", "--version"],
      expected: false,
    },
  ])("detects root-only version invocations: $name", ({ argv, expected }) => {
    expect(isRootVersionInvocation(argv)).toBe(expected);
  });

  it.each([
    {
      name: "root --help",
      argv: ["node", "sudoclaw", "--help"],
      expected: true,
    },
    {
      name: "root -h",
      argv: ["node", "sudoclaw", "-h"],
      expected: true,
    },
    {
      name: "root --help with profile",
      argv: ["node", "sudoclaw", "--profile", "work", "--help"],
      expected: true,
    },
    {
      name: "subcommand --help",
      argv: ["node", "sudoclaw", "status", "--help"],
      expected: false,
    },
    {
      name: "help before subcommand token",
      argv: ["node", "sudoclaw", "--help", "status"],
      expected: false,
    },
    {
      name: "help after -- terminator",
      argv: ["node", "sudoclaw", "nodes", "run", "--", "git", "--help"],
      expected: false,
    },
    {
      name: "unknown root flag before help",
      argv: ["node", "sudoclaw", "--unknown", "--help"],
      expected: false,
    },
    {
      name: "unknown root flag after help",
      argv: ["node", "sudoclaw", "--help", "--unknown"],
      expected: false,
    },
  ])("detects root-only help invocations: $name", ({ argv, expected }) => {
    expect(isRootHelpInvocation(argv)).toBe(expected);
  });

  it.each([
    {
      name: "single command with trailing flag",
      argv: ["node", "sudoclaw", "status", "--json"],
      expected: ["status"],
    },
    {
      name: "two-part command",
      argv: ["node", "sudoclaw", "agents", "list"],
      expected: ["agents", "list"],
    },
    {
      name: "terminator cuts parsing",
      argv: ["node", "sudoclaw", "status", "--", "ignored"],
      expected: ["status"],
    },
  ])("extracts command path: $name", ({ argv, expected }) => {
    expect(getCommandPath(argv, 2)).toEqual(expected);
  });

  it.each([
    {
      name: "returns first command token",
      argv: ["node", "sudoclaw", "agents", "list"],
      expected: "agents",
    },
    {
      name: "returns null when no command exists",
      argv: ["node", "sudoclaw"],
      expected: null,
    },
  ])("returns primary command: $name", ({ argv, expected }) => {
    expect(getPrimaryCommand(argv)).toBe(expected);
  });

  it.each([
    {
      name: "detects flag before terminator",
      argv: ["node", "sudoclaw", "status", "--json"],
      flag: "--json",
      expected: true,
    },
    {
      name: "ignores flag after terminator",
      argv: ["node", "sudoclaw", "--", "--json"],
      flag: "--json",
      expected: false,
    },
  ])("parses boolean flags: $name", ({ argv, flag, expected }) => {
    expect(hasFlag(argv, flag)).toBe(expected);
  });

  it.each([
    {
      name: "value in next token",
      argv: ["node", "sudoclaw", "status", "--timeout", "5000"],
      expected: "5000",
    },
    {
      name: "value in equals form",
      argv: ["node", "sudoclaw", "status", "--timeout=2500"],
      expected: "2500",
    },
    {
      name: "missing value",
      argv: ["node", "sudoclaw", "status", "--timeout"],
      expected: null,
    },
    {
      name: "next token is another flag",
      argv: ["node", "sudoclaw", "status", "--timeout", "--json"],
      expected: null,
    },
    {
      name: "flag appears after terminator",
      argv: ["node", "sudoclaw", "--", "--timeout=99"],
      expected: undefined,
    },
  ])("extracts flag values: $name", ({ argv, expected }) => {
    expect(getFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("parses verbose flags", () => {
    expect(getVerboseFlag(["node", "sudoclaw", "status", "--verbose"])).toBe(true);
    expect(getVerboseFlag(["node", "sudoclaw", "status", "--debug"])).toBe(false);
    expect(getVerboseFlag(["node", "sudoclaw", "status", "--debug"], { includeDebug: true })).toBe(
      true,
    );
  });

  it.each([
    {
      name: "missing flag",
      argv: ["node", "sudoclaw", "status"],
      expected: undefined,
    },
    {
      name: "missing value",
      argv: ["node", "sudoclaw", "status", "--timeout"],
      expected: null,
    },
    {
      name: "valid positive integer",
      argv: ["node", "sudoclaw", "status", "--timeout", "5000"],
      expected: 5000,
    },
    {
      name: "invalid integer",
      argv: ["node", "sudoclaw", "status", "--timeout", "nope"],
      expected: undefined,
    },
  ])("parses positive integer flag values: $name", ({ argv, expected }) => {
    expect(getPositiveIntFlagValue(argv, "--timeout")).toBe(expected);
  });

  it("builds parse argv from raw args", () => {
    const cases = [
      {
        rawArgs: ["node", "sudoclaw", "status"],
        expected: ["node", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node-22", "sudoclaw", "status"],
        expected: ["node-22", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node-22.2.0.exe", "sudoclaw", "status"],
        expected: ["node-22.2.0.exe", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node-22.2", "sudoclaw", "status"],
        expected: ["node-22.2", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node-22.2.exe", "sudoclaw", "status"],
        expected: ["node-22.2.exe", "sudoclaw", "status"],
      },
      {
        rawArgs: ["/usr/bin/node-22.2.0", "sudoclaw", "status"],
        expected: ["/usr/bin/node-22.2.0", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node24", "sudoclaw", "status"],
        expected: ["node24", "sudoclaw", "status"],
      },
      {
        rawArgs: ["/usr/bin/node24", "sudoclaw", "status"],
        expected: ["/usr/bin/node24", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node24.exe", "sudoclaw", "status"],
        expected: ["node24.exe", "sudoclaw", "status"],
      },
      {
        rawArgs: ["nodejs", "sudoclaw", "status"],
        expected: ["nodejs", "sudoclaw", "status"],
      },
      {
        rawArgs: ["node-dev", "sudoclaw", "status"],
        expected: ["node", "sudoclaw", "node-dev", "sudoclaw", "status"],
      },
      {
        rawArgs: ["sudoclaw", "status"],
        expected: ["node", "sudoclaw", "status"],
      },
      {
        rawArgs: ["bun", "src/entry.ts", "status"],
        expected: ["bun", "src/entry.ts", "status"],
      },
    ] as const;

    for (const testCase of cases) {
      const parsed = buildParseArgv({
        programName: "sudoclaw",
        rawArgs: [...testCase.rawArgs],
      });
      expect(parsed).toEqual([...testCase.expected]);
    }
  });

  it("builds parse argv from fallback args", () => {
    const fallbackArgv = buildParseArgv({
      programName: "sudoclaw",
      fallbackArgv: ["status"],
    });
    expect(fallbackArgv).toEqual(["node", "sudoclaw", "status"]);
  });

  it("decides when to migrate state", () => {
    const nonMutatingArgv = [
      ["node", "sudoclaw", "status"],
      ["node", "sudoclaw", "health"],
      ["node", "sudoclaw", "sessions"],
      ["node", "sudoclaw", "config", "get", "update"],
      ["node", "sudoclaw", "config", "unset", "update"],
      ["node", "sudoclaw", "models", "list"],
      ["node", "sudoclaw", "models", "status"],
      ["node", "sudoclaw", "memory", "status"],
      ["node", "sudoclaw", "agent", "--message", "hi"],
    ] as const;
    const mutatingArgv = [
      ["node", "sudoclaw", "agents", "list"],
      ["node", "sudoclaw", "message", "send"],
    ] as const;

    for (const argv of nonMutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(false);
    }
    for (const argv of mutatingArgv) {
      expect(shouldMigrateState([...argv])).toBe(true);
    }
  });

  it.each([
    { path: ["status"], expected: false },
    { path: ["config", "get"], expected: false },
    { path: ["models", "status"], expected: false },
    { path: ["agents", "list"], expected: true },
  ])("reuses command path for migrate state decisions: $path", ({ path, expected }) => {
    expect(shouldMigrateStateFromPath(path)).toBe(expected);
  });
});
