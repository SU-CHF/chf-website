# Post template

To start a new Insights post:

```bash
cp -r insights/_template insights/my-post-slug
```

Then edit `index.qmd`, replace or delete the `image:` line, and remove
`draft: true` when it is ready to publish.

Directories are slug-named with no date prefix, so `/insights/my-post-slug/`
stays stable and quotable; the `date:` field drives ordering on the listing.

Underscore-prefixed directories are ignored by Quarto, so this template is never
rendered or published.
