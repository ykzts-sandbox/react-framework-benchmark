vcl 4.1;

# Proxy the Next.js server. Cache eligibility comes from the built-in VCL
# and the Cache-Control / Vary headers Next.js sends. X-Cache only reports
# HIT, MISS, and PASS.
#
# Observed on Next.js 16.4.0: an RSC request whose URL has no _rsc query
# returns 307 to the same path with ?_rsc or ?_rsc=<hash>. That 307 has no
# Cache-Control and no Vary. A normal cache miss fetch of it replaces the
# HTML object stored for the same URL. Passing these redirects leaves the
# HTML object in place. Payload URLs contain _rsc and stay cacheable when
# Next.js sends s-maxage.

backend default {
  .host = "nextjs";
  .port = "3000";
}

sub vcl_recv {
  if (req.http.RSC && req.url !~ "[?&]_rsc(?:=|&|$)") {
    return (pass);
  }
}

sub vcl_deliver {
  if (obj.uncacheable) {
    set resp.http.X-Cache = "PASS";
  } elsif (obj.hits > 0) {
    set resp.http.X-Cache = "HIT";
  } else {
    set resp.http.X-Cache = "MISS";
  }

  set resp.http.X-Cache-Hits = obj.hits;
}
