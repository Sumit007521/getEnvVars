# getEnvVars

A GitHub Action that fetches environment variables from a repository environment using the `gh` CLI and exports them into the workflow environment. It also writes results to files.

Important workspace files:
- [`action.yml`](action.yml)
- [`index.js`](index.js) (contains the [`run`](index.js) entry)
- [`script.sh`](script.sh)
- [`package.json`](package.json)

## Features
- Retrieves environment variables for a given environment using `gh variable list`.
- Appends JSON output to `env_var.json`.
- Exports each variable into the workflow via `$GITHUB_ENV`.
- Optionally writes an `.env`-style file (`env_var.txt`) when `file_type: env`.

## Prerequisites
- The runner must have the GitHub CLI (`gh`) installed and authenticated.
- `jq` must be available on the runner (used to parse JSON).
- The action uses Node (`node20`) via [`action.yml`](action.yml).

## Inputs
All inputs are defined in [`action.yml`](action.yml).

- [`repo`](action.yml) (optional, default: `${{ github.repository }}`)
  - Description: Repository to query for environment variables (format: `owner/repo`).
- [`env_name`](action.yml) (required)
  - Description: The name of the environment to read variables from.
- [`gh_token`](action.yml) (required)
  - Description: GitHub token used by `gh` for authentication (pass via secrets).
- [`file_type`](action.yml) (optional, default: `json`)
  - Description: Output file format. Supported values in the script: `json` (default) or `env`. When `env`, an `env_var.txt` file is created.

## Outputs / Side effects
- `env_var.json` — JSON array appended with the result of `gh variable list` (created by [`script.sh`](script.sh)).
- `env_var.txt` — When `file_type` is `env`, an `.env`-style file with `NAME=VALUE` lines is created.
- Exports each variable to the workflow environment by appending `NAME=VALUE` lines to `$GITHUB_ENV` (so subsequent steps can read them).

## Example usage
Use the action from the same repository (local action):
```yaml
- name: Get environment variables
  uses: your-username/getEnvVars@main
  with:
    repo: "owner/repo"               # optional, defaults to current repo    
    env_name: "development"          # required
    gh_token: ${{ secrets.GITHUB_TOKEN }}    # required