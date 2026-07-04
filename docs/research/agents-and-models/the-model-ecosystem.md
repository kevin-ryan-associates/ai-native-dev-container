# The Model Ecosystem

## Three Layers That Get Confused

Talk about "the model" usually collapses three distinct things into one, and separating them is the entire purpose of this page. When someone says they are "using GPT" or "running Llama," they may be referring to any of:

- the **lab** that trained the model,
- the **model** artefact itself, or
- the **provider** that serves it over an endpoint.

These are different entities playing different roles, and — crucially — they need not be the same organisation. The lab that created a model and the provider that runs it can be entirely separate companies, under entirely different jurisdictions. That decoupling, where it exists, is the hinge on which much of this section turns, so the page builds toward it deliberately: first the three layers, then the relationship between them.

## Labs: Who Trains the Models

A **lab** is the organisation that trains a model — the origin of the weights. Training a frontier model requires enormous compute, data, and research capability, so labs are relatively few, and each tends to produce a family of models under its own name.

The labs divide most usefully not by who is "ahead" — that changes constantly and is not what a durable reference should track — but by their **release posture**, because that determines what everyone downstream can do with their models:

- **Closed-weight labs** release models only as a hosted service. The weights never leave the lab's control; the model is reachable only through the lab's own API (or partners it authorises). Access is a service you rent, not an artefact you hold.
- **Open-weight labs** publish the trained weights for download. Anyone can run the model on their own infrastructure or serve it commercially. The lab created the model, but it does not control who runs it or where.

Several major labs release open weights; several others release only closed models; and some do both, opening some models while keeping their strongest closed. The important point for a reference is the posture, not the current roster: a lab's release posture is what dictates whether the sovereignty options in the rest of this section are even available for its models.

## Models: The Artefacts

A **model** is the trained artefact a lab produces. Labs ship them in families — a lineage of related models, usually spanning sizes and versions — so that "a model" is really a point in a structure of family, size, and version rather than a single monolith.

The axis that matters most, and that this section returns to repeatedly, is **open-weight versus closed**:

- A **closed model** exists to its users only as an endpoint. Its capabilities can be used, but the artefact cannot be inspected, self-hosted, or run anywhere but the lab's service. Using it means sending data to that service.
- An **open-weight model** is a file you can hold. It can be downloaded, inspected, run on owned hardware, fine-tuned, and served by anyone. Its capabilities come with control.

This is not a quality ranking — open and closed models compete across the capability range — but a **control** distinction, and it is the property that determines whether a model can participate in a sovereign deployment at all. Everything the model-selection material said about weighing open-weight against closed rests on this axis, and everything below about providers is only possible *because* open weights can be served by anyone.

A note on terminology worth keeping straight: "open weights" means the trained parameters are published. It does not necessarily mean open *source* in the full sense — training data, training code, and licence terms vary, and some "open" models carry usage restrictions. The weights being available is what enables self-hosting; the licence governs what you are permitted to do with them. Both matter, and they are separate questions.

## Providers: Who Serves the Models

A **provider** is whoever runs a model behind an endpoint you can call. This is the layer most often overlooked, and it behaves very differently depending on the model's release posture.

For a **closed model**, the lab and the provider are effectively **fused**. Only the lab (and its authorised partners) can serve the model, because only they have the weights. Choosing the model and choosing who serves it are the same choice; there is no independent provider decision to make.

For an **open-weight model**, the lab and the provider are **decoupled**, and this is where the ecosystem opens up. Because the weights are published, *many* providers can serve the same model:

- **Commercial inference providers** host popular open-weight models and sell access to them by the token, competing on price, speed, and available models.
- **Cloud platforms** offer the same models as managed services.
- **Self-hosting** — running the model yourself on owned or rented hardware via an inference server such as vLLM — makes *you* the provider.

The consequence is that a single open-weight model is available from a range of providers at different prices, different latencies and throughputs, and — the point this section cares about most — different **jurisdictions**. The same model can be pulled from a provider in one country, a cloud region in another, or a server in your own facility. The model is identical; the provider is a separate, independent choice.

## The Key Relationship: Decoupling and Sovereignty

The three layers combine into one relationship that is worth stating as the page's central claim.

**For a closed model, the lab is the provider, and choosing the model means accepting that provider's jurisdiction and terms.** There is no separation to exploit. If the lab is foreign-domiciled, using the model imports that jurisdiction, and no amount of configuration changes it — because there is only one place the model runs.

**For an open-weight model, the provider is chosen independently of the lab.** A model trained by a lab in one jurisdiction can be served by a provider in another, or self-hosted inside your own boundary entirely. The origin of the weights and the location of the inference are decoupled. This is precisely why open weights enable sovereignty: they let you keep a model's capabilities while choosing — separately and freely — where the inference actually happens.

This reframes the whole open-versus-closed question one final way. Open weights are not merely "more transparent" or "cheaper." They are the property that **breaks the fusion of model and provider**, and that break is what makes it possible to have a capable model *and* control over where it runs. Closed models offer capability bound to a provider; open-weight models offer capability plus the freedom to choose the provider. For any workload where jurisdiction is a real constraint, that freedom is the entire game.

## Reading the Ecosystem: models.dev

Because the ecosystem is large and moves quickly, a live directory is more useful than any fixed list. **[models.dev](https://models.dev)** is an open, current aggregator of models and providers — covering which models exist, which providers serve them, and their context windows, capabilities, and pricing. It is also the data source that some harnesses (including OpenCode) draw on to populate their provider and model options, which makes it directly relevant to anyone assembling a model-agnostic stack.

Two caveats keep it in proportion. It is a **live directory**, so it should be consulted for current specifics — prices, context windows, which provider serves what — rather than having those specifics copied into a document that will then date. And it is an **aggregator**: a valuable starting map, but the authoritative source for any given model's licence and terms is the lab that published it. Use models.dev to see the shape of the ecosystem and to find providers for a model; verify the details that matter at the source.

## In Short

The model ecosystem has three layers: **labs** train models, **models** are the artefacts they produce, and **providers** serve those models over endpoints. The layers are routinely conflated, but keeping them separate reveals the property that matters most. For closed models, lab and provider are fused, and choosing the model means accepting its jurisdiction. For open-weight models, lab and provider are decoupled, so the model can be served anywhere — by a commercial provider, a cloud, or yourself.

That decoupling is why open weights enable operational sovereignty: they separate *what* the model can do from *where* it runs. A live directory such as models.dev is the practical way to navigate the ecosystem's current specifics, but the durable understanding is structural — know the three layers, know a model's release posture, and you know what your options actually are.
