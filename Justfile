default:
  @just --choose

dev:
  wrangler pages dev --live-reload .

dev-host:
  wrangler pages dev --live-reload --ip 0.0.0.0 .

fmt:
  prettier . -w

lint:
  eslint . --fix
