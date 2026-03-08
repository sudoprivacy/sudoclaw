import fs from "node:fs/promises";
import path from "node:path";
import { afterEach, describe, expect, it, vi } from "vitest";
import type { SudoClawConfig } from "../../config/config.js";
import type { PluginManifestRegistry } from "../../plugins/manifest-registry.js";
import { createTrackedTempDirs } from "../../test-utils/tracked-temp-dirs.js";

const hoisted = vi.hoisted(() => ({
  loadPluginManifestRegistry: vi.fn(),
}));

vi.mock("../../plugins/manifest-registry.js", () => ({
  loadPluginManifestRegistry: (...args: unknown[]) => hoisted.loadPluginManifestRegistry(...args),
}));

const { resolvePluginSkillDirs } = await import("./plugin-skills.js");

const tempDirs = createTrackedTempDirs();

function buildRegistry(params: { acpxRoot: string; helperRoot: string }): PluginManifestRegistry {
  return {
    diagnostics: [],
    plugins: [
      {
        id: "acpx",
        name: "ACPX Runtime",
        channels: [],
        providers: [],
        skills: ["./skills"],
        origin: "workspace",
        rootDir: params.acpxRoot,
        source: params.acpxRoot,
        manifestPath: path.join(params.acpxRoot, "sudoclaw.plugin.json"),
      },
      {
        id: "helper",
        name: "Helper",
        channels: [],
        providers: [],
        skills: ["./skills"],
        origin: "workspace",
        rootDir: params.helperRoot,
        source: params.helperRoot,
        manifestPath: path.join(params.helperRoot, "sudoclaw.plugin.json"),
      },
    ],
  };
}

afterEach(async () => {
  hoisted.loadPluginManifestRegistry.mockReset();
  await tempDirs.cleanup();
});

describe("resolvePluginSkillDirs", () => {
  it("keeps acpx plugin skills when ACP is enabled", async () => {
    const workspaceDir = await tempDirs.make("sudoclaw-");
    const acpxRoot = await tempDirs.make("sudoclaw-acpx-plugin-");
    const helperRoot = await tempDirs.make("sudoclaw-helper-plugin-");
    await fs.mkdir(path.join(acpxRoot, "skills"), { recursive: true });
    await fs.mkdir(path.join(helperRoot, "skills"), { recursive: true });

    hoisted.loadPluginManifestRegistry.mockReturnValue(
      buildRegistry({
        acpxRoot,
        helperRoot,
      }),
    );

    const dirs = resolvePluginSkillDirs({
      workspaceDir,
      config: {
        acp: { enabled: true },
      } as SudoClawConfig,
    });

    expect(dirs).toEqual([path.resolve(acpxRoot, "skills"), path.resolve(helperRoot, "skills")]);
  });

  it("skips acpx plugin skills when ACP is disabled", async () => {
    const workspaceDir = await tempDirs.make("sudoclaw-");
    const acpxRoot = await tempDirs.make("sudoclaw-acpx-plugin-");
    const helperRoot = await tempDirs.make("sudoclaw-helper-plugin-");
    await fs.mkdir(path.join(acpxRoot, "skills"), { recursive: true });
    await fs.mkdir(path.join(helperRoot, "skills"), { recursive: true });

    hoisted.loadPluginManifestRegistry.mockReturnValue(
      buildRegistry({
        acpxRoot,
        helperRoot,
      }),
    );

    const dirs = resolvePluginSkillDirs({
      workspaceDir,
      config: {
        acp: { enabled: false },
      } as SudoClawConfig,
    });

    expect(dirs).toEqual([path.resolve(helperRoot, "skills")]);
  });

  it("rejects plugin skill paths that escape the plugin root", async () => {
    const workspaceDir = await tempDirs.make("sudoclaw-");
    const pluginRoot = await tempDirs.make("sudoclaw-plugin-");
    const outsideDir = await tempDirs.make("sudoclaw-outside-");
    const outsideSkills = path.join(outsideDir, "skills");
    await fs.mkdir(path.join(pluginRoot, "skills"), { recursive: true });
    await fs.mkdir(outsideSkills, { recursive: true });
    const escapePath = path.relative(pluginRoot, outsideSkills);

    hoisted.loadPluginManifestRegistry.mockReturnValue({
      diagnostics: [],
      plugins: [
        {
          id: "helper",
          name: "Helper",
          channels: [],
          providers: [],
          skills: ["./skills", escapePath],
          origin: "workspace",
          rootDir: pluginRoot,
          source: pluginRoot,
          manifestPath: path.join(pluginRoot, "sudoclaw.plugin.json"),
        },
      ],
    } satisfies PluginManifestRegistry);

    const dirs = resolvePluginSkillDirs({
      workspaceDir,
      config: {} as SudoClawConfig,
    });

    expect(dirs).toEqual([path.resolve(pluginRoot, "skills")]);
  });

  it("rejects plugin skill symlinks that resolve outside plugin root", async () => {
    const workspaceDir = await tempDirs.make("sudoclaw-");
    const pluginRoot = await tempDirs.make("sudoclaw-plugin-");
    const outsideDir = await tempDirs.make("sudoclaw-outside-");
    const outsideSkills = path.join(outsideDir, "skills");
    const linkPath = path.join(pluginRoot, "skills-link");
    await fs.mkdir(outsideSkills, { recursive: true });
    await fs.symlink(
      outsideSkills,
      linkPath,
      process.platform === "win32" ? ("junction" as const) : ("dir" as const),
    );

    hoisted.loadPluginManifestRegistry.mockReturnValue({
      diagnostics: [],
      plugins: [
        {
          id: "helper",
          name: "Helper",
          channels: [],
          providers: [],
          skills: ["./skills-link"],
          origin: "workspace",
          rootDir: pluginRoot,
          source: pluginRoot,
          manifestPath: path.join(pluginRoot, "sudoclaw.plugin.json"),
        },
      ],
    } satisfies PluginManifestRegistry);

    const dirs = resolvePluginSkillDirs({
      workspaceDir,
      config: {} as SudoClawConfig,
    });

    expect(dirs).toEqual([]);
  });
});
