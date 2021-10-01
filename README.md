<h2>zzdoc</h2>


This tool generates Swift API documentation.
It is meant to be included in a GitHub action,
and generates API documentation automatically 
in the `gh-pages` branch of your repository.


For example, to generate documentation for the
`GreatLibrary` project that will appear at:

    https://usename.github.io/GreatLibrary/docs/

you would include it in a
`.github/workflows/ci.yml` workflow file:

```yaml
name: GreatLibrary CI

on:
  push:
    branches: [ main ]

jobs:
  ci-macOS:
    runs-on: macos-11
    env:
      #DEVELOPER_DIR: /Applications/Xcode_13.0.app/Contents/Developer
      DEVELOPER_DIR: /Applications/Xcode_13.0_beta.app/Contents/Developer

    timeout-minutes: 10

    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Run tests
        run: xcrun swift test

      - name: Generate docbuild
        run: |
          mkdir -p docs
          touch docs/index.html # needed for Jekyll
          mkdir -p docbuild/output

          xcodebuild docbuild -scheme "GreatLibrary" -destination "platform=macOS" -derivedDataPath docbuild/output/

          cd docbuild/
          git clone https://github.com/marcprux/zzdoc.git
          cd zzdoc
          git checkout $(git describe --tags `git rev-list --tags --max-count=1`) # for latest release; otherwise use main

          swift run zzdoc --verbose --force ../output/Build/Products/Debug/GreatLibrary.doccarchive ../../docs/

      - name: Update Docs
        uses: peaceiris/actions-gh-pages@v3
        if: ${{ github.ref == 'refs/heads/main' }}
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
          force_orphan: true

```


