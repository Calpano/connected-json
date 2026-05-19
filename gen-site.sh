npx antora antora-playbook.yml
# Copy CNAME for custom domain
cp CNAME site/

# Favicon discovery: crawlers (DuckDuckGo's icon proxy used by Umami, etc.)
# probe /favicon.ico directly. Antora's UI bundle only ships favicon.svg
# at /_/img/favicon.svg, and the Antora-generated root index.html is a
# meta-refresh redirect with no <link rel="icon">. Fix both here.
cp modules/_ui/img/favicon.ico site/favicon.ico
# Idempotently inject favicon <link> tags into the root redirect page.
if [ -f site/index.html ] && ! grep -q 'rel="icon"' site/index.html; then
  tmp="$(mktemp)"
  awk '
    /<meta charset="utf-8">/ && !done {
      print
      print "<link rel=\"icon\" href=\"/favicon.ico\" sizes=\"any\">"
      print "<link rel=\"icon\" type=\"image/svg+xml\" href=\"/_/img/favicon.svg\">"
      done = 1
      next
    }
    { print }
  ' site/index.html > "$tmp"
  mv "$tmp" site/index.html
fi
# Copy schemas to clean URLs
mkdir -p site/schema
# Find all schema files and copy to clean paths like /schema/cj-1.2.3.json
find site/connected-json -name 'cj-schema.json' | while read schema; do
  # Extract version from path (e.g., site/connected-json/1.2.3/_attachments/...)
  version=$(echo "$schema" | sed -n 's|site/connected-json/\([0-9][^/]*\)/_attachments/.*|\1|p')
  if [ -n "$version" ]; then
    cp "$schema" "site/schema/cj-${version}.json"
    echo "Copied $schema -> site/schema/cj-${version}.json"
  fi
done
