# PRD: Coaching insights

| Field | Value |
|---|---|
| Owner | Product, Supervisor Experience (invented) |
| Status | Draft for review |
| Written | 2026-08-28 |
| Note | Sample written for the Kaizen Tasks workshop. It is meant to score clarity 3 on the readiness rubric: the behavior is described, the acceptance criteria are not testable. |

## 1. Background

Team supervisors in the contact center run one-on-one coaching sessions with each agent every one or two weeks. Supervisors tell us that preparing for a session takes far longer than the session itself, because the tools show scores per agent but not the reasons behind them. A supervisor who wants to coach an agent on a specific kind of contact has to listen to recordings until one turns up.

In interviews at Larkspur Home Warranty, a supervisor with twelve agents described two hours of preparation for a fifteen-minute conversation, and Sunday evenings spent building coaching packs. She could name the contact reasons where about half of her agents struggle; for the other half she had "a feeling and no evidence."

## 2. Problem

Supervisors cannot see which contact reasons each agent struggles with. Quality scores live in the quality tool, contact reasons live in routing, and no screen joins them. As a result:

- Coaching preparation is done by listening to a sample of interactions, which takes about two hours per session.
- Coaching topics are chosen by impression rather than evidence.
- Agents receive feedback on handle time without knowing what drove it, and cannot tell a slow week from a slow back-office system.

## 3. Goals

- Reduce the time supervisors spend preparing coaching sessions.
- Make coaching topics evidence-based.
- Give supervisors confidence in the interactions they bring to a session.

## 4. Users

- Team supervisors (primary). Twelve agents each on average, mixed chat and voice.
- Quality analysts (secondary), who may use the same view to target evaluations.
- Agents (later), who may see their own view once supervisors trust it.

## 5. Proposed behavior

A new **Coaching insights** page in the supervisor workspace.

When a supervisor opens the page, they see their team as a list. For each agent the page shows the contact reasons where that agent's results are worse than the team over a recent period, and for each of those reasons a few example interactions the supervisor can open directly.

The supervisor can pick an agent to see the detail: the contact reasons ranked by how far the agent is from the team, the trend over the period, and the example interactions with a short note on why each was chosen. The supervisor can mark an example as not useful, and the page should take that into account.

The page should work for chat and voice, and it should separate time the agent spent waiting on systems from time spent with the customer, so that a slow back-office system does not look like a slow agent.

## 6. Out of scope for the first version

- Showing the page to agents.
- Changing how quality scores are calculated.
- Automatic coaching plans or automatic messages to agents.

## 7. Success

- Supervisors report that preparation takes less time.
- Supervisors find the suggested interactions relevant.
- The page is used regularly by the supervisors who have it.

## 8. Open questions

- What is "a recent period": one week, two weeks, a month?
- How many example interactions per contact reason?
- Should "worse than the team" use quality score, handle time, or both?
- What happens for agents with too few interactions in a reason to compare?
- Does this need contact-reason data that the quality tool does not store today?
