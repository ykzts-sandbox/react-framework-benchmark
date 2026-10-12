# Multi-stage build for the Next.js Pages Router benchmark app.
# The runner matches the App Router image: standalone server, static assets,
# and public files only.

ARG NODE_IMAGE=node:24.21.0-alpine

FROM ${NODE_IMAGE} AS deps
WORKDIR /app
COPY apps/next-pages-15/package.json apps/next-pages-15/package-lock.json ./
RUN npm ci --no-audit --no-fund

FROM ${NODE_IMAGE} AS production-deps
WORKDIR /app
COPY apps/next-pages-15/package.json apps/next-pages-15/package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

FROM ${NODE_IMAGE} AS source
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY apps/next-pages-15/ ./
COPY scripts/generate-routes.sh /tmp/generate-routes.sh
ARG STATIC_ROUTES=500
RUN STATIC_ROUTES="$STATIC_ROUTES" sh /tmp/generate-routes.sh /app
ARG BUNDLER=turbopack
ARG EXCLUDE_SHARP=0
ARG STANDALONE=1
ENV BUNDLER=${BUNDLER}
ENV EXCLUDE_SHARP=${EXCLUDE_SHARP}
ENV STANDALONE=${STANDALONE}
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production

# scripts/bench-repeat.sh repeats the timed build in fresh containers of
# the source stage.
FROM source AS builder
ARG STATIC_ROUTES=500
ARG CACHEBUST=0
RUN echo "cold-build bundler=${BUNDLER} static_routes=${STATIC_ROUTES} exclude_sharp=${EXCLUDE_SHARP} standalone=${STANDALONE} cachebust=${CACHEBUST}" \
  && node scripts/timed-build.mjs

# Without output: "standalone". The image keeps the production node_modules
# and the whole .next directory, and runs next start. Build with
# --build-arg STANDALONE=0 --target runner-full.
FROM builder AS full-output
RUN rm -rf .next/cache

FROM ${NODE_IMAGE} AS runner-full
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
ENV STANDALONE=0
COPY --from=production-deps --chown=node:node /app/node_modules ./node_modules
# Next.js 15 needs typescript to load next.config.ts at run time.
COPY --from=deps --chown=node:node /app/node_modules/typescript ./node_modules/typescript
COPY --from=full-output --chown=node:node /app/package.json /app/next.config.ts ./
COPY --from=full-output --chown=node:node /app/public ./public
COPY --from=full-output --chown=node:node /app/.next ./.next
USER node
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]

FROM ${NODE_IMAGE} AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
COPY --from=builder --chown=node:node /app/public ./public
COPY --from=builder --chown=node:node /app/.next/standalone ./
COPY --from=builder --chown=node:node /app/.next/static ./.next/static
USER node
EXPOSE 3000
CMD ["node", "server.js"]
