# ghostty-code

A Ghostty fork with a native sidebar for Claude Code sessions.

`ghostty-code` keeps the terminal as the main workspace while adding a side panel for agentic coding context: running tasks, sessions that need input, drafts, completed work, and review state.

It is inspired by tools like CMUX, but integrates the workflow directly into Ghostty instead of wrapping an external terminal.

## Screenshot

<img width="1800" height="1135" alt="Screenshot 2026-04-01 at 4 32 41 PM" src="https://github.com/user-attachments/assets/617f373f-e30c-4995-9ab3-ba6318854581" />

## Why

Claude Code sessions can run for a while, branch into subtasks, and require occasional input or review.

This project explores what it feels like when that state is visible inside the terminal itself, instead of being scattered across separate panes, editor tabs, notes, or another wrapper app.

## Features

- Ghostty-based terminal experience
- Native task sidebar
- Session states such as Needs Input, Draft, Running, and Done
- At-a-glance view of active Claude Code work
- Designed for keyboard-first agent workflows
- Built directly into the terminal UI rather than around it

## Status

Early-stage experimental fork.

This is not an official Ghostty project and is not intended to replace upstream Ghostty as a general-purpose terminal emulator.

Use the official [Ghostty](https://github.com/ghostty-org/ghostty) if you want the standard Ghostty experience.

## Relationship to Ghostty

This project is a fork of [Ghostty](https://github.com/ghostty-org/ghostty).

All core terminal emulator work comes from Ghostty and its contributors. This fork focuses on additional UI for Claude Code and agent-driven development workflows.

## Build

Build instructions currently follow upstream Ghostty.

See the upstream Ghostty development documentation for now.

## License

This project follows the license of upstream Ghostty.
