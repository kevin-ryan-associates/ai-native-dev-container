# Container Registries

## What a Registry Is

A container registry is the storage and distribution service for container images. When a tool builds an image, it **pushes** it to a registry; when a host runs a container, it **pulls** the image from one. The registry is the link between where images are made and where they run — the supply chain for containers.

Because images conform to the **Open Container Initiative (OCI)** standard, they are registry-agnostic. The same image can live in many registries at once, and a host can pull an identical image from whichever registry it is pointed at. This portability is the single most important property of the registry layer: no registry owns the format, so no registry can lock in the images stored in it.

## The Default: Docker Hub

**Docker Hub** is the default public registry and the one most tooling reaches for unless told otherwise. It is owned and operated by **Docker, Inc.** — the same company that stewards the open-source Docker Engine and CLI and sells the proprietary Docker Desktop.

The distinction worth holding onto is that Docker Hub is a **proprietary, hosted commercial service**, not an open-source component. A fully open-source local setup — Docker Engine or Podman on Linux, no Docker Desktop anywhere — still, by default, pulls its base images *from* Docker Hub. The engine is open; the default image source is a US-company-operated SaaS registry. That is a supply-chain dependency distinct from the openness of the runtime, and it is easy to miss precisely because it is the default.

Two practical characteristics follow:

- **Discoverability.** Docker Hub is where people look for images first. For anyone *publishing* an image for others to find and use, that reach is the reason to publish there.
- **Rate limits.** Docker Hub applies pull-rate limits to anonymous and free-tier usage. Beyond any sovereignty consideration, this is the ordinary operational reason teams mirror images or run a registry of their own — an unauthenticated CI pipeline pulling base images repeatedly will hit the limit.

## Publishing and Consuming Are Different Decisions

The most useful framing for the registry layer is that **publishing and consuming are independent decisions**, driven by different concerns, and the same image can sit on both sides at once.

**Publishing is a discoverability decision.** It is outbound and public. The question is where an audience will find the image, and for that Docker Hub is the pragmatic default because that is where people look. Publishing to Docker Hub does not constrain anything else in the stack.

**Consuming is a supply-chain and sovereignty decision.** It is inbound, and it is where jurisdiction and integrity exposure actually live. For any deployment inside a controlled boundary, the question is not where an image is discoverable but where it is *pulled from*, whether that source is under control, and whether the pulled bytes are verifiably the intended ones.

Crucially, nothing about publishing to a public registry forces production systems to pull from it. An image published to Docker Hub for reach can be pulled in production from a self-hosted registry or a mirror. Distribution reach and operational sovereignty are different problems, and treating them separately is what lets a stack have both.

## The Registry Is a Swappable Component

Because the image format is an open standard, the registry is interchangeable in the same way the container runtime is. The main options fall into three groups:

- **Public hosted registries** — Docker Hub, GitHub Container Registry (GHCR), Quay, and the cloud providers' registries. Chosen mainly for reach and convenience.
- **Self-hosted registries** — the open-source `distribution` project (the reference registry implementation), Harbor (which adds access control, vulnerability scanning, and replication), or the registries built into self-hosted GitLab and Gitea. Chosen when the image source must sit inside a controlled boundary.
- **Mirrors and pull-through caches** — a local cache in front of a public registry, which keeps a controlled copy of upstream images and removes both the rate-limit and the availability dependency on the upstream host.

Multi-registry publishing is inexpensive: because images are OCI-standard, pushing the same image to Docker Hub *and* GHCR *and* a self-hosted registry is one additional target per destination in a CI pipeline. A project can therefore have Docker Hub's discoverability and a sovereign-hosted copy simultaneously, without choosing between them.

## Integrity: Digests and Signing

Which registry hosts an image is only half of supply-chain control. The other half is guaranteeing that the image pulled is exactly the image intended, and that is handled by two mechanisms independent of the registry itself.

**Pin by digest, not tag.** A tag (such as `latest` or `1.0`) is mutable — it can be repointed to different content at any time. A digest (a `sha256` content hash) is immutable: it names exact bytes. For anything consumed in a controlled environment, referencing images by digest rather than by tag is what actually delivers reproducibility and integrity, because the digest cannot be changed to point at something else. This matters more than the choice of host.

**Sign images.** Signing (using Cosign / Sigstore) lets a consumer cryptographically verify that an image genuinely originates from its stated author, regardless of which registry it was pulled from. Signing decouples *trust* from the *host*: an image can be pulled from any mirror or registry and still be verified as authentic. Where provenance matters, signing is the mechanism that provides it.

Together, digest-pinning and signing mean the trust placed in an image does not have to rest on trust in the registry that served it.

## In Short

A container registry stores and distributes OCI images, and because the format is an open standard the registry is a swappable component. Docker Hub, owned by Docker, Inc., is the proprietary default — excellent for discoverability, subject to pull-rate limits, and a supply-chain dependency that persists even in an otherwise fully open-source setup.

The clarifying principle is that publishing and consuming are separate decisions: publish where the audience is (a discoverability decision), pull from where you can control and verify (a supply-chain and sovereignty decision), and use multi-registry publishing to have both. Registry choice governs *where* images live; digest-pinning and signing govern *whether they can be trusted* — and those are the controls that make the supply chain sound regardless of which registry served the image.
