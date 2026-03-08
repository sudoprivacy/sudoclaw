import type { Command } from "commander";
import { formatDocsLink } from "../terminal/links.js";
import { theme } from "../terminal/theme.js";
import { registerQrCli } from "./qr-cli.js";

export function registerOpenclawCli(program: Command) {
  const openclaw = program
    .command("openclaw")
    .description("Legacy openclaw command aliases")
    .addHelpText(
      "after",
      () =>
        `\n${theme.muted("Docs:")} ${formatDocsLink("/cli/openclaw", "docs.sudoclaw.ai/cli/openclaw")}\n`,
    );
  registerQrCli(openclaw);
}
