My goal today was to publish my three previous Elm projects as interactive web pages - not just their source code.

This was super easy!

1. Activate GitHub Pages by going to my GitHub repo's settings, scroll all the way down, and choose `main` as my source.
2. In each project folder, enter `elm make src/Main.elm`, which creates a big scary HTML file we don't need to worry about.
3. Push to GitHub.

All subdirectories in my repo now have a URL, showing `index.html` if it exists, or `readme.md`.

I first tested with just one repo, which showed the compiled HTML file as a web page, while the other two showed `readme.md`, as if it were a regular HTML page. Very cool!

