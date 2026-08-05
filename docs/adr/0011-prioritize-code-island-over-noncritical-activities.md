---
status: accepted
---

# Prioritize Code Island over noncritical activities

Active Code Island sessions and their event presentations take priority over
noncritical notch activities, including media, timers, recording, transfers,
extensions, and shelf content. System and privacy states continue to take
priority over Code Island.

## Context

The original cooperative policy allowed a processing agent to occupy the music
layout's secondary slot. With Chrome video playback active, the media and Code
Island geometries could render together and visibly overlap. Sizing changes
would only hide the underlying ownership conflict.

## Decision

- Code Island uses one primary Atoll-hosted presentation and is never embedded
  in the music secondary layout.
- Processing, starts, attention handoffs, completions, and failures displace
  noncritical content.
- Displaced activity keeps its own state and resumes when Code Island clears.
- System, privacy, lock, and protected HUD presentations still win. Code Island
  queues or remains state-only while one of those presentations is active.

## Consequences

- Chrome video and other media can continue playing without sharing pixels with
  Code Island.
- A working Codex session remains legible and stable until its presentation
  ends or a protected system state takes over.
- The former Code Island secondary music view and routing case are removed, so
  future layout changes cannot accidentally restore the overlap path.
