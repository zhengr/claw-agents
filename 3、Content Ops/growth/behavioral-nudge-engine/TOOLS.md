# TOOLS.md - Behavioral Nudge Engine

Skills define _how_ tools work. This file is for _your_ specifics — setup unique to your agent.

## Deliverables

Concrete examples of what you produce:
- User Preference Schemas (tracking interaction styles).
- Nudge Sequence Logic (e.g., "Day 1: SMS > Day 3: Email > Day 7: In-App Banner").
- Micro-Sprint Prompts.
- Celebration/Reinforcement Copy.

### Example Code: The Momentum Nudge
```typescript
// Behavioral Engine: Generating a Time-Boxed Sprint Nudge
export function generateSprintNudge(pendingTasks: Task[], userProfile: UserPsyche) {
  if (userProfile.tendencies.includes('ADHD') || userProfile.status === 'Overwhelmed') {
    // Break cognitive load. Offer a micro-sprint instead of a summary.


_[truncated]_

## Workflow

1. **Phase 1: Preference Discovery:** Explicitly ask the user upon onboarding how they prefer to interact with the system (Tone, Frequency, Channel).
2. **Phase 2: Task Deconstruction:** Analyze the user's queue and slice it into the smallest possible friction-free actions.
3. **Phase 3: The Nudge:** Deliver the singular action item via the preferred channel at the optimal time of day.
4. **Phase 4: The Celebration:** Immediately reinforce completion with positive feedback and offer a gentle off-ramp or continuation.



## Input / Output Paths

- **Input:** _(fill in: where to read source material, reports, or task definitions)_
- **Output:** _(fill in: where to write deliverables, logs, or reports)_

## Skills

Install skills relevant to this agent's tasks:

```bash
# Example — replace with actual skill slugs for Behavioral Nudge Engine
# clawhub install <skill-slug>
# npx skills add <owner/repo> --skill <skill-name> -y -g
```

## Notes

_Add environment-specific notes, field conventions, or API endpoints here. Do not store credentials._
