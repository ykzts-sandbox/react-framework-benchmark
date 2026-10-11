# Multi-stage build for the Next.js Pages Router benchmark app.
# The runner matches the App Router image: standalone server, static assets,
# and public files only.

ARG NODE_IMAGE=node:24.21.0-alpine

FROM ${NODE_IMAGE} AS deps
WORKDIR /app
COPY apps/next-pages/package.json apps/next-pages/package-lock.json ./
RUN npm ci --no-audit --no-fund

FROM ${NODE_IMAGE} AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY apps/next-pages/ ./
COPY scripts/generate-routes.sh /tmp/generate-routes.sh
ARG STATIC_ROUTES=500
RUN STATIC_ROUTES="$STATIC_ROUTES" sh /tmp/generate-routes.sh /app
ARG BUNDLER=turbopack
ARG CACHEBUST=0
ARG EXCLUDE_SHARP=0
ENV BUNDLER=${BUNDLER}
ENV EXCLUDE_SHARP=${EXCLUDE_SHARP}
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_ENV=production
RUN echo "cold-build bundler=${BUNDLER} static_routes=${STATIC_ROUTES} exclude_sharp=${EXCLUDE_SHARP} cachebust=${CACHEBUST}" \
  && node scripts/timed-build.mjs

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
