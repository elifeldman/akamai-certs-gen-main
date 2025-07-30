# Akamai-certs-gen

---

Automation for Akamai certificate generation.

# Project structure

```
├── .github            # GitHub Actions workflows
├── .globaldots        # "As-is" sources provided by GlobalDots. Are not used in the pipelines
├── conf               # Any configurations related the project scripts
└── scripts            # The optimized scripts to use with the pipelines
```

# Environment variables

Set the environments variables:
```console
$ export contractId=                         # is set in Github Secrets
$ export edgeHostnameId="5032864"
$ export workdir="/workdir/custom-hostname"
$ export property_name="custom-hostname"
```

or fill in the values from a copy of the `.env.example` file and expose the variables in one command:
```console
$ export $(grep -v '^#' .env | xargs)
```

# CI and GitHub Actions

There are two main pipelines that can be run manually:

- [Docker Build](.github/workflows/docker-build.yml) - is used as a part of the CI process or just to rebuild a Docker image
- [Run Akamai Cli](.github/workflows/akamai-cli.yml) - the main pipeline to trigger Akamai Cli. It can be run in three modes:

1. status: get certificate status (default)
2. activate: create certificate, hostname and activate property
3. delete: delete certificate

The mode is selected from the dropdown menu in the workflow inputs.

# WAF update
## Script imports hostname that have been added on production property and puts them on new version of Security Configuration


Script is triggered as workflow call from Run akamai cli workflow 
- Input hostname is taken from RUN Akamai CLI 
- Job runs for activation action only
- Script operates Akamai APIs and using edgerc data stored in secrets


Comments in code provides the workflow details



To see what hostnames have been added check job log for output: "Hostnames to be added:"

### by DEFAULT new version will be activated on STAGING AKAMAI network so before going to prod it needs to be changed along with notification emails

