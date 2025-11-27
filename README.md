
# Web4application — Project Knowledge Base Site

Static, no-dependency site that turns your mind‑map into a searchable website.

## Files
- `index.html` — main page
- `styles.css` — modern, accessible styling
- `app.js` — renders sections from embedded JSON, includes live search
- `assets/project-mindmap.png` — the provided diagram image
- `data.json` — content as JSON (mirrored inside `index.html` for easy deploy)

## Local preview
Open `index.html` directly in a browser, or run a tiny server:

```bash
python3 -m http.server 8080
```

## Deploy
- **GitHub Pages**: commit to a repo, enable Pages on the `main` branch (root).  
- **Vercel/Netlify**: import the repo; set output directory to the project root.

## Edit content
Update section lists in `data.json`, then copy the JSON object into the inline
`window.__SITE_DATA__` in `index.html` (or adjust `app.js` to fetch the JSON).

---
Built with ❤️ for Web4application.
