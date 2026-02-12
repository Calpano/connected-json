npx antora antora-playbook.yml
# Copy CNAME for custom domain
cp CNAME site/
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
