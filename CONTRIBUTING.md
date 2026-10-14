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
The pull request title becomes the line in the release notes, so write it for users.

| Label | Release notes section |
| --- | --- |
| `enhancement` | Features & Improvements |
| `bug` | Bug Fixes |
| `dependencies` | Dependencies (Dependabot adds this automatically) |
| `skip-changelog` | Excluded from release notes |
| none of the above | Other Changes |

## Releasing

Releases are published by [`.github/workflows/release.yml`](.github/workflows/release.yml) when a `v*` tag is pushed.

One-time setup: on RubyGems.org, add a Trusted Publisher for this gem with repository `kazu-2020/fractional_indexer`, workflow `release.yml`, and environment `release`.

1. Bump `FractionalIndexer::VERSION` in `lib/fractional_indexer/version.rb` and merge it into `main`.
2. Tag the merged commit and push the tag:

   ```sh
   git tag v0.4.2
   git push origin v0.4.2
   ```

The workflow checks that the tag matches `VERSION`, runs the tests, publishes the gem to RubyGems.org via Trusted Publishing, and creates a GitHub Release with generated notes.
