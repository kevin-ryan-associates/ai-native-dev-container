# Model Selection

## Selection Is Routing, Not a Single Choice

The naïve view of model selection is "pick the best model." The harness view is different and more useful: **model selection is a routing strategy** — matching each task to a model along several axes at once, rather than crowning one model and using it for everything.

This follows directly from the model-swapping foundation. Because a harness talks to every model through a standard interface, the model is a component that can be chosen per task rather than fixed for the whole system. The previous material explained *how* swapping is possible; this page is about *how to decide what to swap to*. The interface makes the choice cheap; this page is about making it well.

The reframe matters because "best model" is not even a coherent target. Best at what — peak reasoning, lowest cost, fastest response, running inside your own boundary? Those pull in different directions, and no single model wins all of them. Selection is the discipline of trading them off deliberately, task by task.

## The Axes a Selection Decision Turns On

A model choice is a point in a space defined by several independent axes. Naming them explicitly is what turns selection from instinct into engineering.

**Capability.** How good the model is at the work — reasoning depth, coding ability, and, most importantly for agents, **tool-calling reliability**. This last point is easy to miss: an agent's success depends less on raw eloquence than on whether the model consistently emits well-formed tool calls, picks the right tool, and drives the loop without derailing. A model that benchmarks well on one-shot problems but calls tools unreliably makes a poor agent. Capability for an agent is agentic capability, which is not the same as headline capability.

**Cost.** Nominally this is price per token, but the number that actually matters is **cost per completed task**, and the two can diverge sharply. A cheaper model that fails, retries, thrashes, and burns tokens recovering from its own mistakes can cost more to finish a job than an expensive model that does it right the first time. Per-token price is an input; cost-per-outcome is the metric.

**Latency and throughput.** These are distinct and each favours different models. Interactive work — a developer waiting at a prompt — wants low latency and fast first-token response. Parallel or batch work — many sub-agents running concurrently, an overnight job processing a queue — wants high throughput and cares little about the latency of any single call. A model that is ideal for one can be wrong for the other.

**Context window.** How much the model can hold at once gates what kind of task it can take on. A large-context model can be handed a sprawling multi-file problem directly; a smaller-context model needs the harness to work harder at curation and compaction (which ties back to context-management mechanics). Window size is a selection criterion because it changes what the surrounding harness has to do.

**Jurisdiction and sovereignty.** The axis most model comparisons ignore entirely, and the one that connects to the legal and sovereignty material. *Where* inference runs and *who has legal reach over it* is a selection criterion as real as capability or cost. A frontier model behind a foreign-domiciled API and an open-weight model on owned hardware are not just different price/capability points — they sit under different legal regimes. For any workload where sovereignty is a genuine requirement, this axis can be decisive on its own, overriding a capability advantage.

These axes are independent, and a real decision weighs several simultaneously. The skill is knowing which axis binds for a given task — sometimes it is capability, sometimes cost, sometimes jurisdiction — and choosing on that basis rather than defaulting to whichever model is most famous.

## The Tiering Pattern

The mature expression of selection-as-routing is **tiering**: maintaining a small set of models at different capability/cost points and routing each step of a workflow to the cheapest tier that can handle it. A representative pattern:

- **A fast, inexpensive tier** for mechanical and high-volume steps — simple edits, lookups, classification, formatting decisions, routing decisions themselves. These are frequent and individually easy, so spending a frontier model on them is waste.
- **A strong reasoning tier** for the hard parts — architecture, multi-file refactors, debugging subtle failures, anything where a wrong decision is expensive to unwind. Here the capable model earns its cost because it changes the outcome.
- **A throughput-oriented tier** for parallel execution — when many sub-tasks run at once and aggregate speed matters more than any single response.

The value of tiering is that it turns the model from a fixed cost into a tuned one. The expensive model is spent only where it moves the needle; the cheap model absorbs the volume. Done well, this can cut cost substantially while leaving quality untouched on the steps that actually determine the result — because the steps that determine the result are exactly the ones routed to the strong tier.

Tiering is a harness-level capability. The harness decides, per step, which tier to call — sometimes by explicit configuration, sometimes by a routing rule, sometimes by asking a cheap model to classify the difficulty before dispatching. This is one of the clearest places where good harness design directly reduces cost, and it is only possible because the model-agnostic interface makes calling three models as easy as calling one.

## Open-Weight Versus Frontier as a Selection Question

The choice between an open-weight model (self-hostable, run on infrastructure you control) and a frontier model (accessed through a provider's API) is often framed as a philosophical or ideological one. For selection purposes it is better treated as a straightforward question of what each buys and what each costs.

**Frontier models** offer peak capability and zero infrastructure burden. Someone else runs the hardware, handles scaling, and ships the improvements. The price is real: you import the provider's jurisdiction into your stack, accept a dependency on their continued access and terms, and send your code and context outside your boundary to be processed.

**Open-weight models** offer control, sovereignty, cost predictability, and freedom from a specific vendor's terms. Inference runs where you put it — including entirely within your own boundary. The price is also real: you carry the infrastructure, the operational burden, and the scaling, and you usually accept some gap from the peak of frontier capability.

The honest current picture is that this gap has narrowed enough that, **for many tasks though not all**, an open-weight model is now sufficient. That sufficiency is precisely what makes routing viable: if open-weight models were uniformly far behind, there would be nothing to route to. Because they are competitive on a large fraction of everyday work, a sound strategy is frequently a blend — open-weight, self-hosted models handling the tasks they can (which, with tiering, is most of the volume), with frontier capability reserved for the genuinely hardest problems or, in sovereignty-sensitive deployments, avoided where the jurisdiction cost is unacceptable. Open-weight versus frontier is not a binary allegiance; it is another routing decision, made per task along the axes above — with jurisdiction weighted according to how much sovereignty the workload actually demands.

## Two Honest Caveats

Two things are worth stating plainly because they are widely gotten wrong.

**Benchmarks are a weak selection signal.** Public leaderboards are contaminated (newer models have often seen the test sets), they typically measure one-shot problem solving rather than multi-step agentic execution, and they barely capture tool-calling reliability — the property that most determines whether a model works as an agent. A model can top a benchmark and still make a mediocre agent. The sound basis for selection is a **representative task suite of your own** — the evaluation discipline from the harness material — run against the candidate models in your actual harness. What matters is how a model performs at your work, inside your loop, not how it ranks on a generic list.

**Selection is dynamic, not a one-time procurement.** The right model for a task is not fixed. Models update, prices move, new options appear, and your workload shifts. A choice that was correct three months ago may be wrong now. The payoff of the model-agnostic axis is precisely that revisiting the choice is cheap — changing an endpoint, a key, and a model name. Treat selection as a standing decision to re-examine, not a contract signed once. A harness built on a standard interface makes this re-examination nearly free, which is the whole point of having built it that way.

## In Short

Model selection is routing: matching each task to a model along the axes of capability, cost-per-outcome, latency and throughput, context window, and jurisdiction — with tiering as the pattern that puts cheap models on the volume and expensive models only where they change the result. Open-weight versus frontier is one more routing decision within that frame, decided per task with sovereignty weighted to the workload's real needs, and made viable by how far open-weight capability has closed the gap.

Select on your own tasks rather than on leaderboards, and treat the decision as one you revisit rather than one you settle. The model-agnostic interface is what makes all of this cheap; model selection is the discipline of using that freedom well.
