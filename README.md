# actions-techdocs

Github Action for Backstage's techdocs plugin from Spotify.

## What does it do?

It scans the whole repository for the following files:

- `mkdocs.yaml`
- `catalog-info.yaml`

The action has two commands:

- `check` - runs `mkdocs build` in all directories containing `mkdocs.yaml` and checks for any warnings or errors in the output
- `publish` - runs `techdocs publish` in all directories containing `catalog-info.yaml` and `mkdocs.yaml` (the catalog file is used to extract kind/namespace/name of entity)

## Usage

```yaml
jobs:
  techdocs:
    name: Check & Publish
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v3

      # Runs mkdocs check in all directories containing **/mkdocs.yaml file
      - name: Run mkdocs check
        uses: TwistoPayments/actions-techdocs@main
        with:
          command: check

      # Runs techdocs generate and techdocs publish commands in all directories containgin
      # **/mkdocs.yaml file. Currently only S3 publisher is supported.
      - name: Run techdocs publish
        uses: TwistoPayments/actions-techdocs@main
        with:
          command: publish
        env:
          TECHDOCS_PUBLISHER_TYPE: awsS3
          TECHDOCS_S3_BUCKET_NAME: ${{ secrets.TECHDOCS_S3_BUCKET_NAME }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_REGION: ${{ secrets.AWS_REGION }}
```

Alternatively, you can pull image from Docker Hub which will be faster as you won't need to build the image each time, just replace

```yaml
        uses: TwistoPayments/actions-techdocs@main
        with:
          command: <check/publish>
```

with

```yaml
        uses: docker://twistopayments/actions-techdocs:main
        with:
          args: <check/publish>
````
