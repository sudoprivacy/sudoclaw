import type { SudoClawPluginApi } from "sudoclaw/plugin-sdk";
import { emptyPluginConfigSchema } from "sudoclaw/plugin-sdk";
import { createSynologyChatPlugin } from "./src/channel.js";
import { setSynologyRuntime } from "./src/runtime.js";

const plugin = {
  id: "synology-chat",
  name: "Synology Chat",
  description: "Native Synology Chat channel plugin for SudoClaw",
  configSchema: emptyPluginConfigSchema(),
  register(api: SudoClawPluginApi) {
    setSynologyRuntime(api.runtime);
    api.registerChannel({ plugin: createSynologyChatPlugin() });
  },
};

export default plugin;
