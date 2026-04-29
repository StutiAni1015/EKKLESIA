const express  = require("express");
const Anthropic = require("@anthropic-ai/sdk");
const protect   = require("../middleware/authMiddleware");

const router = express.Router();
const client = new Anthropic();

const SYSTEM_PROMPT = `You are Spiritual Companion, a wise, empathetic, and biblically-grounded AI assistant for the Ekklesia faith community app.

Your capabilities:
- **Bible Q&A**: Answer any question about the Bible — theology, history, characters, prophecy, and meaning — always citing scripture references (Book Chapter:Verse).
- **Scripture Identification**: When a user pastes or types a biblical text snippet, identify exactly where it comes from (book, chapter, verse) and provide brief context.
- **Spiritual Counselling**: Offer compassionate, non-judgmental encouragement grounded in scripture. Listen deeply, validate feelings, and point gently to God's love and promises.
- **Bible Quiz**: When asked to quiz the user, generate one clear quiz question at a time (multiple-choice or open-ended), wait for their answer, then give the correct answer with an explanation and scripture reference. Keep a running score if the user wants to continue.
- **Reflection & Notes**: Help users process their faith journey. When a user wants to save a thought, remind them to tap the bookmark icon to save it to their journal.

Tone guidelines:
- Warm, humble, and hopeful — never preachy or judgmental.
- Concise but meaningful — aim for 3–6 sentences per response unless the question demands more depth.
- When quoting scripture, always include the reference in parentheses, e.g. (John 3:16).
- When you do not know something, say so honestly and suggest they consult their pastor or a biblical commentary.

You are speaking directly to a member of a faith community. Treat every message with care and respect.`;

// ── POST /api/companion/chat ───────────────────────────────────────────────────
// Body: { messages: [{ role: 'user'|'assistant', content: string }] }
router.post("/chat", protect, async (req, res) => {
  try {
    const { messages } = req.body;

    if (!Array.isArray(messages) || messages.length === 0) {
      return res.status(400).json({ message: "messages array is required" });
    }

    // Validate & sanitise each message
    const sanitised = messages
      .filter((m) => m && (m.role === "user" || m.role === "assistant") && typeof m.content === "string")
      .map((m) => ({ role: m.role, content: m.content.slice(0, 4000) })); // cap per message

    if (sanitised.length === 0) {
      return res.status(400).json({ message: "No valid messages provided" });
    }

    const response = await client.messages.create({
      model: "claude-sonnet-4-6",
      max_tokens: 1024,
      system: SYSTEM_PROMPT,
      messages: sanitised,
    });

    const reply = response.content?.[0]?.text ?? "I'm sorry, I could not generate a response right now.";
    res.json({ reply });
  } catch (err) {
    console.error("[companion] error:", err.message);
    res.status(500).json({ message: "Spiritual Companion is temporarily unavailable. Please try again." });
  }
});

module.exports = router;
