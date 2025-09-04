#!/usr/bin/env bash
set -e
SITE_DIR="site"
mkdir -p "$SITE_DIR"

# Find all markdown files (excluding README.md and index)
find . -maxdepth 1 -name '*.md' ! -name 'README.md' ! -name 'index.md' | while read -r mdfile; do
  base=$(basename "$mdfile" .md)
  # Compile to HTML
  marp "$mdfile" -o "$SITE_DIR/$base.html" --theme kartoza.css
  # Compile to PDF
  marp "$mdfile" -o "$SITE_DIR/$base.pdf" --theme kartoza.css
  # Extract year and title for index
  year=$(grep -m1 '^date:' "$mdfile" | awk '{print $2}')
  title=$(grep -m1 '^title:' "$mdfile" | cut -d':' -f2 | xargs)
  echo "$year|$title|$base" >> "$SITE_DIR/decks.txt"
done

# Sort and build index.html
sort -t'|' -k1,1nr -k2,2 "$SITE_DIR/decks.txt" | awk -F'|' '{print "<tr><td>" $1 "</td><td>" $2 "</td><td><a href=\"" $3 ".html\">HTML</a> | <a href=\"" $3 ".pdf\">PDF</a></td></tr>"}' > "$SITE_DIR/decks_rows.html"

cat > "$SITE_DIR/index.html" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Kartoza Marp Slide Decks</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.4/css/bulma.min.css">
</head>
<body>
  <section class="section">
    <div class="container">
      <h1 class="title">Kartoza Marp Slide Decks</h1>
      <table class="table is-striped is-hoverable">
        <thead><tr><th>Year</th><th>Title</th><th>Links</th></tr></thead>
        <tbody>
EOF
cat "$SITE_DIR/decks_rows.html" >> "$SITE_DIR/index.html"
echo "        </tbody>\n      </table>\n    </div>\n  </section>\n</body>\n</html>" >> "$SITE_DIR/index.html"

rm "$SITE_DIR/decks.txt" "$SITE_DIR/decks_rows.html"
