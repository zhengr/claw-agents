# HEARTBEAT.md

When the agent receives a heartbeat poll, it reads this file. **Keep this file empty (or comments only) to skip doing anything** — the agent will reply `HEARTBEAT_OK`.

Add tasks below when you want the agent to **check something periodically** (e.g. 2–4 times per day). Keep the list short to limit token use.

---

## Heartbeat vs Cron

| Use **heartbeat** when | Use **cron** when |
|------------------------|-------------------|
| Several checks can run together in one turn (e.g. inbox + calendar + reminders) | Exact time matters (e.g. "every Monday 9:00") |
| You want recent chat context in the same session | Task should run in isolation from the main session |
| Timing can drift a bit (e.g. every ~30 min) | One-shot or fixed schedule |
| You want fewer API calls by batching checks | Different model or separate process for the task |

---

## What to add below

- **Reminders** — e.g. "Check tomorrow's meetings; remind if any need prep."
- **Periodic checks** — e.g. "Check inbox for urgent unread; summarize if any."
- **Light maintenance** — e.g. "Review recent `memory/YYYY-MM-DD.md`; update `MEMORY.md` if something important."

**Optional:** Track last run in `memory/heartbeat-state.json` so the agent doesn't repeat the same work (e.g. `{"lastChecks":{"calendar":1703275200}}`).

**When nothing needs doing:** The agent should reply `HEARTBEAT_OK`. Don't send messages or take external action unless the user has agreed to that as heartbeat behavior.

---

## Tasks (add below this line)

# - Example: Check calendar for next 24h; remind if meetings need materials.
# - Example: Scan today's memory file; suggest one follow-up.
