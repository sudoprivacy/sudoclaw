import type {
  AnyAgentTool,
  SudoClawPluginApi,
  SudoClawPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: SudoClawPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as SudoClawPluginToolFactory,
    { optional: true },
  );
}
