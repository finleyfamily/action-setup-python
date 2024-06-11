#! /usr/bin/env bash

set -eo pipefail
shopt -s extglob

PIP_ARGS="";  # store args to pass to `pipx install --pip-args=...`

if [[ "${INPUT_POETRY_PREVIEW}" == "true" ]]; then
  PIP_ARGS="--pre";
fi;

pipx ensurepath;

case "${INPUT_POETRY_VERSION}" in
  latest)
    pipx install poetry --pip-args="${PIP_ARGS}";
    ;;
  ~*|==*|\>*|\<*)
    pipx install "poetry${INPUT_POETRY_VERSION}" --pip-args="${PIP_ARGS}";
    ;;
  @(0|1|2|3|4|5|6|7|8|9)*)
    echo "poetry-version input appears to contain an explicit version; please add a prefix of '==' to ensure propper functionality";
    pipx install "poetry==${INPUT_POETRY_VERSION}" --pip-args="${PIP_ARGS}";
    ;;
  *)
    echo "poetry-version input value of ${INPUT_POETRY_VERSION} does not appear to be a valid version specifier or 'latest'";
    echo "please update the value and try again";
    exit 1;
    ;;
esac

poetry config virtualenvs.create true
poetry config virtualenvs.in-project true
poetry config virtualenvs.prefer-active-python true

pipx inject poetry poetry-plugin-export;
poetry config warnings.export false;

for plugin in ${INPUT_POETRY_PLUGINS}; do
  pipx inject poetry "${plugin}";
done
