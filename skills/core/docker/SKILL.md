---
name: docker
description: >
  Language-agnostic containerization principles. Multi-stage builds, base
  image selection, security, layer optimization. Use with language-specific
  docker skill for build patterns.
---

# Docker

Build small, secure, production-ready containers.

## Base Image Selection

| Image Type | Size | Use Case |
|---|---|---|
| scratch | ~0MB | Static binaries only |
| distroless/static | ~2MB | Static binaries, better debugging |
| distroless/base | ~20MB | Binaries needing libc |
| alpine | ~5MB | Need shell/debugging tools |
| debian:slim | ~70MB | Complex dependencies |

**Default**: distroless/static for production (security + small size). Alpine for development.

## Multi-Stage Builds

1. **Build stage**: full SDK/toolchain image, compile application
2. **Runtime stage**: minimal image, copy only the binary/artifacts

Reduces image size 90-95% vs single-stage builds.

## Layer Caching

Order instructions for maximum cache reuse:
1. Copy dependency manifests first (changes infrequently)
2. Install dependencies
3. Copy source code last (changes frequently)
4. Build

Code-only changes reuse cached dependency layers.

## Security

- **Non-root user**: always run as non-root (UID 65532 standard)
- **Pin versions**: never use `:latest` — pin base image versions and digests
- **No secrets in layers**: use build secrets (`--mount=type=secret`), not `ARG`/`ENV`
- **Minimal runtime**: no shells, package managers, or unnecessary tools

## .dockerignore

Exclude from build context: `.git`, docs, tests, IDE files, `.env`, build artifacts, `node_modules`/`vendor`.

## Health Checks

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/app", "healthcheck"]
```

## Build Metadata

Use OCI labels and build args for version, commit, build date injection.

## Anti-Patterns

- Unpinned base images — non-reproducible builds
- Secrets in layer history — use `--mount=type=secret`
- Installing unnecessary packages in runtime image
- Running as root
- Single-stage builds with full SDK in production
