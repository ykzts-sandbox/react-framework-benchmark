STATIC_ROUTES ?= 500
export STATIC_ROUTES

.PHONY: generate bench repeat charts compressed varnish-up varnish-down varnish-verify

generate:
	sh scripts/generate-routes.sh apps/next apps/next-15 apps/next-pages apps/next-pages-15 apps/react-router apps/react-router-data apps/react-router-declarative

bench:
	sh scripts/bench.sh

repeat:
	sh scripts/bench-repeat.sh

charts:
	node scripts/render-charts.mjs

compressed:
	sh scripts/measure-compressed.sh \
		node:24.21.0-alpine \
		benchmark-next:webpack \
		benchmark-next:webpack-no-sharp \
		benchmark-next:turbopack \
		benchmark-next:turbopack-no-sharp \
		benchmark-next:rspack \
		benchmark-next:rspack-no-sharp \
		benchmark-next-15:webpack \
		benchmark-next-15:webpack-no-sharp \
		benchmark-next-15:turbopack \
		benchmark-next-15:turbopack-no-sharp \
		benchmark-next-15:rspack \
		benchmark-next-15:rspack-no-sharp \
		benchmark-next-pages:webpack \
		benchmark-next-pages:webpack-no-sharp \
		benchmark-next-pages:turbopack \
		benchmark-next-pages:turbopack-no-sharp \
		benchmark-next-pages:rspack \
		benchmark-next-pages:rspack-no-sharp \
		benchmark-next-pages-15:webpack \
		benchmark-next-pages-15:webpack-no-sharp \
		benchmark-next-pages-15:turbopack \
		benchmark-next-pages-15:turbopack-no-sharp \
		benchmark-next-pages-15:rspack \
		benchmark-next-pages-15:rspack-no-sharp \
		benchmark-next:webpack-full \
		benchmark-next-15:webpack-full \
		benchmark-next-pages:webpack-full \
		benchmark-next-pages-15:webpack-full \
		benchmark-next:turbopack-full \
		benchmark-next-15:turbopack-full \
		benchmark-next-pages:turbopack-full \
		benchmark-next-pages-15:turbopack-full \
		benchmark-react-router:vite \
		benchmark-react-router-data:vite \
		benchmark-react-router-declarative:vite

varnish-up:
	docker compose up -d --build mysql laravel nextjs react-router varnish

varnish-down:
	docker compose down

varnish-verify:
	sh scripts/verify-varnish.sh
