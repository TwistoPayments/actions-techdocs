FROM public.ecr.aws/twisto/node:18-alpine

ENV version=1.3

# Metadata
LABEL name=techdocs-check version=$version \
    maintainer="Pavel Dedik <dedikx@gmail.com>"

RUN apk add --no-cache bash py3-pip chromium && \
    python3 -m venv /venv && \
    . /venv/bin/activate && \
    pip install --no-cache mkdocs-techdocs-core && \
    pip install --no-cache shyaml && \
    pip install --no-cache markdown-inline-mermaid && \
    deactivate

# keep Node 18 and install versions that are compatible with it
RUN npm install -g @techdocs/cli@1.9.5 @mermaid-js/mermaid-cli@10.9.1

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

WORKDIR /app

COPY mkdocs-check.sh /usr/local/bin/mkdocs-check
COPY techdocs-publish.sh /usr/local/bin/techdocs-publish
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

USER nobody

ENTRYPOINT ["entrypoint.sh"]
