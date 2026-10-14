# Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/kazu-2020/fractional_indexer>.

## Development

```sh
bin/setup
bundle exec rake
bundle exec rubocop
```

## Pull request labels

Release notes are generated from merged pull requests, grouped by label (configured in [`.github/release.yml`](.github/release.yml)).
The pull request title becomes the line in the release notes, so write it in English for users.
Dependabot pull requests are left out of the release notes.

| Label | Release notes section |
| --- | --- |
| `breaking-change` | Breaking Changes |
| `enhancement` | Features & Improvements |
| `bug` | Bug Fixes |
| `skip-changelog` | Excluded (use for changes users don't see, such as tests and CI) |
| none of the above | Other Changes |

## Releasing

Releases are published by [`.github/workflows/release.yml`](.github/workflows/release.yml), which is run manually.

One-time setup:

- On RubyGems.org, add a Trusted Publisher for this gem with repository `kazu-2020/fractional_indexer`, workflow `release.yml`, and environment `release`.
- In the repository settings, restrict the `release` environment's deployment branches to `main`.

1. Bump `FractionalIndexer::VERSION` in `lib/fractional_indexer/version.rb` and merge it into `main`.
2. Once CI on `main` is green, open **Actions → Release → Run workflow** and run it on `main`.

The workflow runs the tests, tags the commit as `v<VERSION>`, publishes the gem to RubyGems.org via Trusted Publishing, and creates a GitHub Release with generated notes. It does nothing when run on any branch other than `main`.

If the gem is published but the GitHub Release step fails, re-running the workflow will not help. Create the release by hand with `gh release create v<VERSION> --generate-notes`.
