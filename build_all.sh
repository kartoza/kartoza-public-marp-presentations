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
  <style>
    body {
      background: #fff;
      color: #222;
    }
    .kartoza-header {
      color: #DF9E2F;
      font-weight: 700;
      letter-spacing: 1px;
      margin-bottom: 1rem;
    }
    .kartoza-table thead {
      background: #569FC6;
      color: #fff;
    }
    .kartoza-table tr:hover {
      background: #F9F6F2;
    }
    .kartoza-link {
      color: #569FC6;
      font-weight: 500;
    }
    .kartoza-logo {
      width: 80px;
      margin-bottom: 1rem;
    }
  </style>
</head>
<body>
  <section class="section">
    <div class="container">
      <img src="https://raw.githubusercontent.com/kartoza/kartoza-public-marp-presentations/main/img/KartozaNixOS.png" alt="Kartoza Logo" class="kartoza-logo">
      <h1 class="title kartoza-header">Kartoza Marp Slide Decks</h1>
      <table class="table is-striped is-hoverable kartoza-table">
        <thead><tr><th>Year</th><th>Title</th><th>Links</th></tr></thead>
        <tbody>
EOF
cat "$SITE_DIR/decks_rows.html" >> "$SITE_DIR/index.html"
echo "        </tbody>      </table>\n      <p style=\"margin-top:2rem;color:#569FC6;font-weight:500;\">Made with ❤️ by Kartoza</p>\n    </div>\n  </section>\n</body>\n</html>" >> "$SITE_DIR/index.html"

rm "$SITE_DIR/decks.txt" "$SITE_DIR/decks_rows.html"
