# Multi-stage build for the React Router benchmark app.
# The dependency split follows the official React Router Docker template:
# development dependencies are used only to build, and the runner receives
# production dependencies plus the Vite build output.

ARG NODE_IMAGE=node:24.21.0-alpine

FROM ${NODE_IMAGE} AS development-dependencies
WORKDIR /app
COPY apps/react-router/package.json apps/react-router/package-lock.json ./
RUN npm ci --no-audit --no-fund

FROM ${NODE_IMAGE} AS production-dependencies
WORKDIR /app
COPY apps/react-router/package.json apps/react-router/package-lock.json ./
RUN npm ci --omit=dev --no-audit --no-fund

FROM ${NODE_IMAGE} AS builder
WORKDIR /app
COPY --from=development-dependencies /app/node_modules ./node_modules
COPY apps/react-router/ ./
COPY scripts/generate-routes.sh /tmp/generate-routes.sh
ARG STATIC_ROUTES=500
RUN STATIC_ROUTES="$STATIC_ROUTES" sh /tmp/generate-routes.sh /app
ARG CACHEBUST=0
ENV NODE_ENV=production
RUN echo "cold-build static_routes=${STATIC_ROUTES} cachebust=${CACHEBUST}" \
  && node scripts/timed-build.mjs

FROM ${NODE_IMAGE} AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=production-dependencies --chown=node:node /app/node_modules ./node_modules
COPY --from=builder --chown=node:node /app/package.json ./package.json
COPY --from=builder --chown=node:node /app/build ./build
COPY --from=builder --chown=node:node /app/public ./public
USER node
EXPOSE 3000
CMD ["node_modules/.bin/react-router-serve", "./build/server/index.js"]
