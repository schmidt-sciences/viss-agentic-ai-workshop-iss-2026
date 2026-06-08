# Block 2: Further Reading

Curated, opinionated. We are deliberately _not_ trying to survey the
field, we want resources that build the **mental model** Block 2 set up.

## The post-training pipeline, end to end

- **Andrej Karpathy, [Intro to Large Language Models](https://www.youtube.com/watch?v=zjkBMFhNj_g)** (YouTube, ~1h). The single best "warm up your intuition" talk. Watch the post-training portion (~30 min in) if you only have 30 minutes.
- **Sebastian Raschka, [Build a Large Language Model from Scratch](https://sebastianraschka.com/books/) and his blog on RLHF / DPO**. Accessible, from-first-principles writing on every stage we covered.

## The papers behind each stage

- **OpenAI, [Training language models to follow instructions with human feedback](https://arxiv.org/abs/2203.02155)** (the InstructGPT paper, 2022). The canonical SFT + RLHF combination.
- **Anthropic, [Constitutional AI: Harmlessness from AI Feedback](https://arxiv.org/abs/2212.08073)**. RLHF where the preferences come from a model graded against a written constitution.
- **Rafailov et al., [Direct Preference Optimization](https://arxiv.org/abs/2305.18290)** (the DPO paper). Skip the explicit reward model; optimize the policy directly from preference pairs.
- **DeepSeek, [DeepSeek-R1: Incentivizing Reasoning Capability in LLMs via Reinforcement Learning](https://arxiv.org/abs/2501.12948)**. A recent, accessible example of RL applied to reasoning, the same shape as agentic RL applied to tool use.

## Tool use and agentic RL

- **Anthropic, [Tool use overview](https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/overview)**. The wire format the notebook used.
- **Anthropic, [Building effective agents](https://www.anthropic.com/research/building-effective-agents)**.
- **Anthropic, [Software engineering using Claude](https://www.anthropic.com/engineering)** (engineering blog, ongoing). Real-world write-ups of Claude Code's design, the closest thing to "what agentic RL looks like in production" without an academic paper.

## Companion to slide 8 ("trained in vs in the prompt")

- **Simon Willison, [his blog at large](https://simonwillison.net/)** (pick any recent post). Simon documents case after case where "the model can't do X" turned out to be "I phrased it badly." A good feel for how often the prompt side, the part you control, is worth checking first.
- **Anthropic, [Claude's character / training methodology](https://www.anthropic.com/news/claude-character)**. Useful for understanding what "training in" personality and helpfulness actually looks like.

---

If you find a great resource that should be here, open a PR.
