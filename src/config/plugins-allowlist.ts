import type { SudoClawConfig } from "./config.js";

export function ensurePluginAllowlisted(cfg: SudoClawConfig, pluginId: string): SudoClawConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}
