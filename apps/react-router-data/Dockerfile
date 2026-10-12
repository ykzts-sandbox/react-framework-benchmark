# Multi-stage build for the React Router Data Mode benchmark app.
# The runner serves dist/ with a small Node static server. Production
# node_modules are not copied. This is a static SPA deploy, unlike Framework
# Mode, which follows the official React Router Docker template.

ARG NODE_IMAGE=node:24.21.0-alpine

FROM ${NODE_IMAGE} AS deps
WORKDIR /app
COPY apps/react-router-data/package.json apps/react-router-data/package-lock.json ./
RUN npm ci --no-audit --no-fund

FROM ${NODE_IMAGE} AS source
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY apps/react-router-data/ ./
COPY scripts/generate-routes.sh /tmp/generate-routes.sh
COPY scripts/timed-spa-build.mjs ./scripts/timed-build.mjs
ARG STATIC_ROUTES=500
RUN STATIC_ROUTES="$STATIC_ROUTES" sh /tmp/generate-routes.sh /app
ENV BENCHMARK_MODE=data
ENV NODE_ENV=production

# scripts/bench-repeat.sh repeats the timed build in fresh containers of
# the source stage.
FROM source AS builder
ARG STATIC_ROUTES=500
ARG CACHEBUST=0
RUN echo "cold-build mode=data static_routes=${STATIC_ROUTES} cachebust=${CACHEBUST}" \
  && node scripts/timed-build.mjs

FROM ${NODE_IMAGE} AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --chown=node:node scripts/spa-server.mjs ./server.mjs
USER node
EXPOSE 3000
CMD ["node", "server.mjs"]
