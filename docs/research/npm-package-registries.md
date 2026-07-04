# npm Package Registries

## What a Package Registry Is

A package registry is the storage and distribution service for software dependencies. When a project declares a dependency and a package manager resolves it, the packages are fetched from a registry. It is the same role a container registry plays for images, applied to language-level libraries: the supply chain through which third-party code enters a project.

For the JavaScript ecosystem, the package manager is the **npm CLI**, and the question this page answers is where `npm install` fetches from by default, who controls that source, and how the dependency supply chain can be brought inside a controlled boundary.

## The Default: The Public npm Registry

When `npm install <package>` runs, it fetches from the **public npm registry** at `https://registry.npmjs.org` unless configured otherwise. This is the default source for the entire npm ecosystem.

The ownership picture mirrors the container-registry situation almost exactly:

- The npm registry and the npm CLI are operated and maintained by **npm, Inc.**, which **GitHub acquired in 2020**, placing it ultimately under **Microsoft**. It shares a corporate parent with GitHub Container Registry and GitHub itself.
- The **npm CLI is open source** (Artistic License 2.0). The **public registry service is proprietary and hosted.**

This is the same split documented for Docker: an open-source client paired with a proprietary, company-operated hosted service. An otherwise fully open toolchain still, by default, pulls its dependencies from a Microsoft-owned SaaS registry — a supply-chain dependency that is easy to overlook precisely because it is the default and requires no configuration to invoke.

## The Registry Is Configurable and Swappable

As with container images, the default is not a lock. The registry the npm CLI uses is configurable at several levels:

- **Globally** — `npm config set registry <url>` repoints all installs.
- **Per project** — an `.npmrc` file in the project sets the registry for that project, so the choice travels with the repository.
- **Per scope** — a package namespace can be routed independently, for example sending `@yourorg/*` to a private registry while everything else resolves from the public one. This is the common pattern for mixing private internal packages with public dependencies.

Alternative and self-hosted registries fill the same roles their container equivalents do:

- **Verdaccio** — open source, and the usual sovereign choice. It is lightweight and typically run as a proxy and cache in front of the public registry, giving a controlled boundary through which dependencies pass.
- **GitHub Packages, GitLab's package registry, JFrog Artifactory, Sonatype Nexus** — hosted or self-hosted registries used for private packages, mirroring, or enterprise policy control.

A Verdaccio-style **pull-through cache** provides the same benefit as a container mirror: a controlled copy of upstream packages, insulation from upstream availability or removal, and a single boundary the dependencies must cross. This matters in an ecosystem where packages can be unpublished or altered upstream — a local cache is protection against a dependency disappearing as much as against jurisdiction.

## Integrity: Lockfiles and Provenance

Choosing the registry is only part of supply-chain control. The other part is guaranteeing that the packages installed are exactly the ones intended. The npm ecosystem handles this differently from containers, and the honest picture is that one mechanism is strong and universal while the other is still emerging.

**Lockfiles are the strong, universal mechanism.** A `package-lock.json` pins every dependency — direct and transitive — to an exact version and records an integrity hash (`sha512`) for each. This is the digest-pinning equivalent from the container world: it makes installs reproducible and detects tampering, because a package whose contents do not match the recorded hash will be rejected. In automation, `npm ci` installs strictly from the lockfile and fails if `package.json` and the lockfile disagree, which is the correct command for CI and reproducible builds. Lockfile integrity is reliable and applies to every dependency.

**Provenance is the newer, weaker mechanism.** npm supports build **provenance attestations** — cryptographic evidence, via Sigstore and tied to a CI pipeline, that a package was built from a specific source at a specific commit. This is the closest analogue to container image signing. The important caveat is coverage: provenance is opt-in for publishers and most packages do not yet publish it, so it cannot be relied on universally the way lockfile hashes can. It is a genuine and improving capability, not yet a guarantee that spans the ecosystem.

The practical consequence: lockfile integrity hashes give reproducibility and tamper-detection today, across all dependencies, and should be treated as the baseline. Provenance adds stronger origin guarantees where it is available but is not something to assume is present.

## In Short

The default source for `npm install` is the public npm registry at `registry.npmjs.org`, owned — via GitHub — by Microsoft, and structured like Docker Hub: an open-source CLI in front of a proprietary, hosted registry service. That default is a real supply-chain dependency, and it persists even in an otherwise open toolchain until it is deliberately repointed.

The registry is swappable through configuration — globally, per project, or per scope — and self-hostable with tools such as Verdaccio, which can run as a controlled pull-through cache. Reproducibility and tamper-detection come from lockfiles and their integrity hashes, which are universal and reliable; cryptographic provenance is emerging but not yet ubiquitous. As with container registries, the registry governs *where* dependencies come from, while lockfiles and provenance govern *whether they can be trusted* — and the two concerns are best controlled separately.
