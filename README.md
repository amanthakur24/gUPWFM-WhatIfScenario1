# SupportOps Decision Lab

An independent, Google-inspired support operations decision-support **portfolio prototype**. It is **not affiliated with Google** and uses synthetic data.

## Live dashboard

Open `index.html` in a modern browser. No installation, R server, Python, or internet connection is required. The JavaScript-powered simulator runs entirely in the browser.

## GitHub Pages (free)

1. Create a **public** GitHub repository, e.g. `supportops-decision-lab`.
2. **Extract this ZIP first**, then upload its **contents** (especially `index.html`) to the repository root. Do not upload the ZIP as a single file.
3. Go to **Settings → Pages → Build and deployment → Deploy from a branch**.
4. Choose **main**, **/(root)**, and **Save**.
5. Visit `https://YOUR-USERNAME.github.io/supportops-decision-lab/` once the deployment completes.

## Contents

- `index.html`: fully self-contained browser-based dashboard with embedded synthetic interval data and interactive simulations.
- `erlang_c_reference.R`: independent base-R Erlang C / scenario calculation reference.
- `.nojekyll`: disables Jekyll processing for static deployment.

## Methodological scope

This is a scenario planning demonstration, **not a validated production forecast**. Its Erlang C illustration assumes a stationary, single-skill, first-come-first-served queue, approximately Poisson arrivals, exponential service times, and no abandonment. It models theoretical service level rather than observed customer outcomes. Labor costs are illustrative, and no proprietary or confidential Google data is included.

## Interview demonstration

Start with baseline service level → try a demand shock → inspect staffed capacity and cost impacts → discuss interventions, sensitivity, assumptions and model applicability.
