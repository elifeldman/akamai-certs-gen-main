#FROM akamai/shell:latest
FROM akamai/shell:v2.8.1

ENV PROPERTY="custom-hostname"
ARG PROPERTY=$PROPERTY

WORKDIR /workdir

# Create user and required folders
RUN adduser -D -s /bin/sh akamai

# Run as non-root user
USER akamai

# Download of CPS enrollments and common names for faster local retrieval and
# Import an existing property in Property Manager locally
RUN --mount=type=secret,id=edgerc,target=/home/akamai/.edgerc,uid=1000 \
    akamai cps setup --section default && \
    akamai property-manager import -p $PROPERTY --section default

# Copy required files from the repo
COPY --chown=akamai:akamai conf/ conf/
COPY --chown=akamai:akamai scripts/ scripts/
COPY --chown=akamai:akamai .env .env

ENTRYPOINT ["bash", "scripts/menu.sh"]
