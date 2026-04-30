const express     = require("express");
const { execFile } = require("child_process");
const protect     = require("../middleware/authMiddleware");

const router = express.Router();

// Use the Claude Code binary — already authenticated via user's account.
// Falls back to the standard `claude` CLI if env var is unset.
const CLAUDE_BIN = process.env.CLAUDE_CODE_EXECPATH || "claude";

const SYSTEM_PROMPT = `You are Ezer, a warm and biblically-grounded spiritual companion inside the Ekklesia faith community app.

Your capabilities:
- Bible Q&A: Answer questions about the Bible — theology, history, characters, prophecy — always citing scripture (Book Chapter:Verse).
- Scripture Identification: When a user shares a text snippet, identify where it comes from and give brief context.
- Spiritual Counselling: Offer compassionate, non-judgmental encouragement grounded in scripture.
- Bible Quiz: Generate one clear quiz question at a time. Wait for their answer, then give the correct answer with scripture reference.
- Reflection & Notes: Help users process their faith journey. Remind them to tap the bookmark icon to save a thought to their journal.

Tone: Warm, humble, hopeful — never preachy. Concise (3–6 sentences) unless depth is needed.
Always include scripture references in parentheses, e.g. (John 3:16).
When you don't know something, say so honestly.`;

function buildPrompt(messages) {
  const history = messages
    .map((m) => `${m.role === "user" ? "User" : "Ezer"}: ${m.content}`)
    .join("\n\n");
  return `${SYSTEM_PROMPT}\n\n---\n\n${history}\n\nEzer:`;
}

// ── POST /api/companion/chat ───────────────────────────────────────────────────
router.post("/chat", protect, async (req, res) => {
  try {
    const { messages } = req.body;

    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ message: "messages array is required" });
    }

    const sanitised = messages
      .filter((m) => m && (m.role === "user" || m.role === "assistant") && typeof m.content === "string")
      .map((m) => ({ role: m.role, content: m.content.slice(0, 4000) }));

    if (sanitised.length === 0) {
      return res.status(400).json({ message: "No valid messages provided" });
    }

    const prompt = buildPrompt(sanitised);

    const reply = await new Promise((resolve, reject) => {
      execFile(
        CLAUDE_BIN,
        ["-p", prompt, "--model", "claude-haiku-4-5"],
        { timeout: 30000, maxBuffer: 2 * 1024 * 1024 },
        (err, stdout) => {
          if (err) return reject(err);
          resolve(stdout.trim());
        }
      );
    });

    res.json({ reply });
  } catch (err) {
    console.error("[companion] error:", err.message);
    res.status(500).json({ message: "Spiritual Companion is temporarily unavailable. Please try again." });
  }
});

module.exports = router;
