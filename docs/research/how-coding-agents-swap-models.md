# How Coding Agents Swap Models: The OpenAI Chat Interface as a De Facto Standard

## Why This Matters

The AI coding agent landscape divides tools along an axis of *model-agnostic* versus *locked to one provider*. That distinction only exists because a technical foundation makes model-swapping possible in the first place. Understanding that foundation is fundamental: it explains why some agents can list dozens of providers, why open-weight models running on private hardware can slot into the same tools as frontier cloud models, and — importantly — why "just change the model" is mechanically trivial but operationally deceptive.

This page explains the mechanism, its origin, the cases where it breaks down, and the caveats that separate the marketing claim from the engineering reality.

## The Anatomy of a Model Call

A coding agent is a **harness around a model**. The harness manages the loop — reading files, running commands, editing code — but it does not contain intelligence. To decide what to do next, it makes an HTTP request to a model and reads the response.

That request, in its now-standard form, is a JSON body sent to an endpoint. It contains a handful of fields:

- a `model` string naming which model to run,
- a `messages` array — the conversation so far, as a list of role-tagged turns (`system`, `user`, `assistant`, and `tool`),
- a `tools` schema describing the functions the model is allowed to call,
- sampling parameters such as `temperature` and `max_tokens`,
- and a `stream` flag.

A minimal request looks like this:

```json
POST https://api.openai.com/v1/chat/completions
{
  "model": "gpt-4o",
  "messages": [
    { "role": "system", "content": "You are a coding agent." },
    { "role": "user", "content": "List the files in the current directory." }
  ],
  "tools": [ /* function schemas the agent exposes */ ],
  "stream": true
}
```

The response comes back in a matching shape: a `choices` array whose `message` may contain either text or a `tool_calls` list. When streaming, the same content arrives as a sequence of server-sent events (SSE), each carrying a `delta` — an incremental fragment of the message — until a terminating event closes the stream.

This request/response pair is the entire interface between harness and model. Everything the agent does at the model boundary passes through it.

## Why One Shape Became the Standard

The schema above is OpenAI's **Chat Completions** format. It was not designed to be an industry standard; it became one because it arrived early, was simple, and was widely adopted before alternatives matured. Tool authors wrote their harnesses against it, and the weight of that existing code created gravity: any new model provider that wanted immediate compatibility with the existing ecosystem of tools had a strong incentive to expose an endpoint in the same shape rather than inventing its own.

The result is that `/v1/chat/completions` — with its `messages` array, its role tags, its `tools` block, and its SSE streaming — functions as a de facto wire standard. It is cloned far beyond OpenAI itself. This is the single most important fact for understanding model-swapping: the interface is a shared, reimplementable convention, not a proprietary lock.

## The Swap Mechanism

Once a harness is written against the Chat Completions shape, changing the model collapses to changing three values:

- the **`base_url`** — where the request is sent,
- the **API key** — which credential authenticates it,
- the **`model`** string — which model the endpoint should run.

Nothing else in the code path moves. The harness constructs the same JSON, parses the same response, and drives the same tool-execution loop regardless of what is answering on the other end. Concretely, pointing an agent at a different provider is often a matter of configuration rather than code:

```
# Frontier cloud model
base_url = https://api.openai.com/v1
model    = gpt-4o

# A different provider, same interface
base_url = https://api.some-inference-provider.com/v1
model    = qwen3-32b
```

This is why tools like OpenCode, Aider, and Cline can advertise many providers at once. They are not maintaining many separate API integrations. They are pointing one Chat Completions-shaped client at many endpoints that all speak the same dialect.

## Local and Sovereign Inference: The Same Dialect

The swap mechanism extends to models running on private or self-hosted infrastructure because the serving layers adopted the same interface. The major open inference servers — vLLM, Ollama, llama.cpp's server, LM Studio, SGLang, and others — all expose an OpenAI-compatible `/v1/chat/completions` endpoint.

The consequence is significant. An open-weight model such as a Qwen or GLM variant, running on an operator's own GPU server, presents itself to the harness exactly as a cloud API would. The harness cannot distinguish a frontier model behind a commercial endpoint from a local model behind `localhost`, and it does not need to. Both are just a `base_url`, a key (or none), and a `model` string.

This is the technical bedrock beneath the "open harness plus open-weight model, all inside a controlled boundary" architecture. It is only possible because the interface is a standard that self-hosted servers can implement freely. If model access required a proprietary, provider-specific protocol, sovereign and local deployment would be impossible — the standard interface is precisely what keeps both the harness and the inference within a boundary the operator controls.

## Where Providers Diverge

The picture is not uniform. Not every provider is OpenAI-compatible, and the divergences are real.

The most significant is **Anthropic's Messages API**. It differs in ways that matter to a harness: the system prompt is a top-level parameter rather than a message with a `system` role; message content is structured as an array of typed blocks (text, tool use, tool results) rather than plain strings; the tool-use request and result format is its own; and `max_tokens` is required rather than optional. A client written purely for Chat Completions cannot talk to it without translation.

**Google's Gemini API** diverges again — different endpoint conventions, a `contents`/`parts` structure, `systemInstruction` handling, and a `functionDeclarations` tool format — and requires its own handling.

So the "one interface" reality is better stated as: one interface *dominates*, several important providers sit outside it, and any harness aiming for broad reach must bridge the gap.

## The Gateway and Adapter Pattern

Harnesses close that gap in one of two ways.

Some ship **per-provider adapters** internally: small translation layers that convert the harness's common internal representation into each provider's native format and back. The harness reasons in one shape and speaks several dialects at its edge.

Others **offload translation to a gateway**. Tools such as LiteLLM, OpenRouter, and models.dev present a single OpenAI-compatible surface to the harness and perform the per-provider translation behind it. The harness only ever speaks Chat Completions; the gateway handles the divergence for Anthropic, Google, and everyone else. This is why a tool can claim support for "75+ providers" without carrying seventy-five integrations — it carries one, pointed at a gateway that carries the rest.

Both approaches preserve the same outcome: from the harness's point of view, switching models remains a change of endpoint, key, and model name.

## The Leaky Abstraction: The Honest Caveat

Here is the part that separates an accurate understanding from a misleading one. The wire format standardises, but **behaviour does not**. Swapping the model is mechanically free and can be operationally drastic. The interface holds constant while the competence delivered through it varies enormously.

The specific places the abstraction leaks:

- **Tool-calling reliability.** The tool schema is uniform across providers, but whether a model actually emits well-formed tool calls, chooses the right tool, and recovers from errors in the agentic loop is a property of the model, not the interface. This is the single biggest source of variation. A harness that works beautifully with one model can stall or thrash with another that speaks the identical protocol.
- **Context window.** Models differ by orders of magnitude in how much they can hold. An agent workflow tuned for a large window can break when pointed at a smaller one, even though the request shape is identical.
- **Prompt caching.** Caching mechanisms are provider-specific — some explicit, some automatic — and materially affect cost and latency for the repeated, context-heavy calls that agents make. It does not transfer across a swap.
- **Structured output.** JSON mode, response-format constraints, and grammar-constrained decoding are unevenly supported and differently specified.
- **Reasoning and thinking parameters.** Controls for extended reasoning are provider-specific and do not map cleanly from one model family to another.
- **Token accounting and pricing.** Tokenisation, usage reporting, and price per token differ across providers, so cost is not predictable from the interface alone.

In short: "change the model by changing a string" is true, and "the results will be equivalent" is not. The swap is trivial; the *agentic quality* on the other side is the real variable. This is the harness effect viewed from the model side — the harness stays constant, the protocol stays constant, and the model is still what decides whether the loop actually works.

## Summary

Model-swapping inside coding agents rests on a single fact: OpenAI's Chat Completions format became a de facto wire standard that most of the ecosystem — including open, self-hostable inference servers — reimplemented. That standard reduces "changing the model" to changing an endpoint, a key, and a model name, which is what makes both broad multi-provider support and sovereign local inference possible.

The qualifications are equally fundamental. Several major providers (notably Anthropic and Google) sit outside the standard and are reached through adapters or gateways. And the standard interface guarantees only that the request will be accepted, not that the model behind it will drive the agent competently. The interface is portable; capability is not. Choose the harness for its workflow and openness; choose the model, still, for what it can actually do.
