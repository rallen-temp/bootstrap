Set Homebrew Github API Token

When you don't set an API token, you get an error similar to this after doing too many homebrew searches or installs:

No formula found for "end-to-end".
==> Searching pull requests...
Error: GitHub API Error: API rate limit exceeded for 69.250.252.214. (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)
Try again in 41 minutes 45 seconds, or create a personal access token:
  https://github.com/settings/tokens/new?scopes=&description=Homebrew
and then set the token as: export HOMEBREW_GITHUB_API_TOKEN="your_new_token"

ec93b13dbf6fb4bd59a778c8aefaf0268770f738