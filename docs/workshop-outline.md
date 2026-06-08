# Coding with AI Agents: A Hands-On Workshop for Scientists

*2026 Interdisciplinary Science Summit, Raleigh, NC*

## Overview

The landscape of software development is being reshaped by AI coding agents, tools that go far beyond autocomplete to plan, write, debug, and iterate on software autonomously. For scientists who write code as part of their research, understanding how to effectively leverage these agents is rapidly becoming an essential skill.

Many scientists have already started experimenting with AI-assisted coding, and the goal of this workshop is to explain and empower researchers to go from early exploration to the more powerful agent-based workflows that are now available.

This workshop will equip scientists with a practical, grounded understanding of AI coding agents: how they work under the hood, how to set them up, and how to use them effectively for real research software tasks. Our goal is not to chase the latest shiny tool, but to teach durable concepts and transferable skills that remain valuable regardless of which model or AI product leads the market next quarter.

## Motivation

Scientists already write substantial software to power their research, from data pipelines, methods and simulations to analysis frameworks and visualization tools. But the AI-assisted development ecosystem is evolving so quickly that even experienced industry developers struggle to keep up, and the available resources are fragmented, hype-driven, and rarely tailored to research contexts. We aim to fill that gap by distilling what we've learned from tracking this fast-moving space into scientific software workflows and practical guidance, so attendees can make better-informed decisions about their own coding-with-AI practices.

We also want to be opinionated about where it matters. Rather than offering a neutral survey, we will present experiential arguments about why and how these models work so well for coding tasks and where they fall short, giving attendees the conceptual tools to evaluate new developments on their own.

## Workshop Structure

The workshop is designed as a hands-on, interactive session rather than a lecture. It is organized into four blocks:

### Block 1: The AI Coding Agent Landscape (30 minutes)

A focused introduction to the current ecosystem of AI coding agents, including tools like Claude Code, GitHub Copilot, Cursor, and OpenCode, with practical guidance on choosing and setting one up. Rather than exhaustively covering every option, we will go deep on one or two representative tools and enumerate the rest, helping attendees understand the key dimensions of choice: cost, capability, integration, and model hosting (API vs. cloud vs. self-hosted). We will also cover the anatomy of a coding agent: the LLM backbone, tool use, planning modes, configuration files (e.g., `AGENTS.md`), MCP servers, and skills. We will also show a brief demo of a working agent.

### Block 2: How It Actually Works: A Primer on Post-Training and Tool Calling (30 minutes)

A conceptual overview of how base large language models (LLMs) are post-trained to become capable coding agents. This block gives attendees the intuition they need to understand why agent behaviors like tool calling, planning, and iterative debugging work the way they do. The goal is to build a mental model that outlasts any single product release. If you understand how Claude Code or ChatGPT are built, you can anticipate and potentially influence the next generation of tools before they arrive.

### Block 3: Agent-Driven Research Software Engineering (30 minutes)

A live demonstration to show the full research-plan-implement cycle: an AI agent that researches a problem, produces a plan aligned with Scientific Python community guidelines, and generates an implementation. This block showcases how to apply agents to real research software engineering tasks and serves as a bridge to the final hands-on session. We will also discuss practical use cases (feature implementation, debugging, test writing, documentation, code review, and exploratory coding) as well as common failure modes (context window exhaustion, looping, poor performance on niche languages) and how to mitigate them.

### Block 4: Build Your Own Skill (Remaining Time)

Guided, hands-on session where attendees construct a simple skill of their own. This is the capstone exercise: having seen the concepts, the internals, and a polished demo, participants will now get their hands dirty wiring together the components themselves. Instructors will circulate to provide support, and scaffolded starter materials will be provided. If participants are able, they may bring along snippets of code / data they are interested in using.

### Following Day: Optional Office Hours

Join us the following day to continue the work from Block 4. VISS members will be available to answer questions about how to try out your agent on your own data or workflows, writing your own skills/plugins, and agentic research workflows in general.

## Prerequisites

- Each participant must have:
  - A GitHub account that gets added to the team: [2026-viss-ai-workshop-participants](https://github.com/orgs/schmidt-sciences/teams/2026-viss-ai-workshop-participants)
    - **Note:** Must provide GitHub handle ahead of time for the above.
  - A laptop with a modern browser and terminal access
    - **Preferred:** Chromium-based browser
- What Schmidt Sciences and the VISS centers will provide:
  - GitHub Codespaces allocation for organization-level access for participants
  - AWS Bedrock instance of Claude for use by participants during the workshop and next day's office hours

## Workshop Instructors and Developers

*Virtual Institutes for Scientific Software*

Anant Mittal, Carlos García Jurado Suarez, Anshul Tambay, Vani Mandava, Robert Bates, Ryan Hausen, Eric Liu, Tina Dang, Arfon Smith

## Contact

- **Anshul Tambay**, University of Washington Scientific Software Engineering Center, [anshul37@uw.edu](mailto:anshul37@uw.edu)
- **Tina Dang**, Schmidt Sciences, [tdang@schmidtsciences.org](mailto:tdang@schmidtsciences.org)
