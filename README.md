# Kartoza Marp Presentations

This repository provides a collection of Marp presentations created by Kartoza. Each presentation is written in Markdown and can be compiled into beautiful slide decks (HTML and PDF) using the Marp CLI.

## Purpose

- To host and share Kartoza's public presentations in a consistent, accessible format.
- To enable easy compilation and publishing of slide decks to GitHub Pages.
- To provide an index page listing all presentations, sorted by year and title, with a modern Bulma-styled interface.

## How to Use

1. **View Presentations:**
   - Visit the GitHub Pages site (see repository settings) for a browsable list of all slide decks.
2. **Build Locally:**
   - Run `bash build_all.sh` to compile all presentations into the `site/` directory.
   - The index page (`site/index.html`) will list all decks with links to HTML and PDF versions.
3. **Contribute:**
   - Add new presentations as Markdown files (one per deck).
   - Ensure each file includes metadata (e.g., `title:` and `date:`) for proper indexing.

## Technologies Used

- [Marp CLI](https://marp.app/): Markdown presentation tool
- [Bulma](https://bulma.io/): CSS framework for the index page
- GitHub Actions: Automated build and deployment to GitHub Pages

## License
See [LICENSE](./LICENSE) for details.

---

_Made with ❤️ by Kartoza._
