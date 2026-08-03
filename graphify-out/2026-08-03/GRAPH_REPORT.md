# Graph Report - bestaroundrevisited  (2026-08-03)

## Corpus Check
- 4 files · ~755 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 17 nodes · 16 edges · 4 communities (3 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d1fdc61b`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- BestAroundRevisited.lua
- CLAUDE.md
- WIKR - Best Around (Revisited)

## God Nodes (most connected - your core abstractions)
1. `_print()` - 3 edges
2. `playSound()` - 2 edges
3. `printUsage()` - 2 edges
4. `updateSettings()` - 2 edges
5. `eventHandler()` - 2 edges
6. `WIKR - Best Around (Revisited)` - 2 edges
7. `Project overview` - 1 edges
8. `Architecture` - 1 edges
9. `Adding a new toggle setting` - 1 edges
10. `Testing` - 1 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (4 total, 1 thin omitted)

### Community 0 - "BestAroundRevisited.lua"
Cohesion: 0.43
Nodes (5): eventHandler(), playSound(), _print(), printUsage(), updateSettings()

### Community 1 - "CLAUDE.md"
Cohesion: 0.33
Nodes (4): Adding a new toggle setting, Architecture, Project overview, Testing

## Knowledge Gaps
- **5 isolated node(s):** `Project overview`, `Architecture`, `Adding a new toggle setting`, `Testing`, `Description`
  These have ≤1 connection - possible missing edges or undocumented components.
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **What connects `Project overview`, `Architecture`, `Adding a new toggle setting` to the rest of the system?**
  _5 weakly-connected nodes found - possible documentation gaps or missing edges._