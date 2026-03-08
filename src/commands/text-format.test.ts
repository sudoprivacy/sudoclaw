import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("sudoclaw", 16)).toBe("sudoclaw");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("sudoclaw-status-output", 10)).toBe("sudoclaw-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});
