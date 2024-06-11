# action-setup-python

A composite GitHub Action that sets up both Python and poetry with virtual environment caching in a single step.

This Action was started because I found myself repeating the same steps over and over again across jobs.
Since Actions don't currently support YAML anchors, this was my next best option.

> [!CAUTION]
> This Action can and will undergo breaking changes until there is a `v1.0.0`.
> There are a few features still lacking from the newly release composite Actions that are needed to improve functionality.
> The primary feature being support for conditions.

<!-- mdformat-toc start --slug=github --no-anchors --maxlevel=6 --minlevel=2 -->

- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

<!-- mdformat-toc end -->

## Features

- uses [pipx] to install [poetry]
  - as of implementation, this is [poetry]'s recommended install method
  - uses [pipx] that comes pre-installed on all [GitHub Runner images](https://github.com/actions/runner-images#available-images)
  - caches [pipx] directories
- sets the following global [poetry] configuration values:
  - `virtualenvs.create = true`
  - `virtualenvs.in-project = true`
  - `virtualenvs.prefer-active-python = true`
- injects [poetry-plugin-export](https://github.com/python-poetry/poetry-plugin-export) into the [pipx] install of [poetry]
  - in the future this plugin will not be installed by default with poetry
  - disables [poetry]'s warning regarding the future remove of this plugin
- _(optional)_ checks the constancy of `poetry.lock`
- _(optional)_ installs dependencies using [poetry]

## Requirements

- [actions/checkout](https://github.com/actions/checkout) needs to be run **before** this Action
- the virtual environment needs to be created within the project for it to be cached (`poetry config --local virtualenvs.in-project true`)
  - this is set globally by the action but if it is set to `false` locally, it will take precedence

## Usage

```yaml
steps:
  - uses: actions/checkout@v2
  - uses: ITProKyle/action-setup-python@v0.1.0 # it is HIGHLY recommended to pin this to a release
    with:
      python-version: 3.9
```

### Inputs

| Key                     | Description                                                                                                                                                                                                                                                                                                |
| ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| architecture            | The target architecture (x86, x64) of the Python interpreter.The target architecture (x86, x64) of the Python interpreter.                                                                                                                                                                                 |
| cache-key-suffix        | Temporary input to allow for slight customization of the cache key until full customization can be provided. This will be removed in the future.                                                                                                                                                           |
| ensure-cache-is-healthy | Ensure the cached Python virtual environment is healthy. In most cases, this should be left set to `true` (default). _(non-Windows only)_                                                                                                                                                                  |
| poetry-check            | Whether validate the content of the `pyproject.toml` file and its consistency with the `poetry.lock` file.                                                                                                                                                                                                 |
| poetry-check-cmd        | The poetry command to run when checking the lock file (e.g. `check`). This command was changed in poetry 1.6 (default used by this action). To support older versions of poetry, provide a value for this input.                                                                                           |
| poetry-install          | Whether to run `poetry install` (or the value of `poetry-install-cmd`). Defaults to `true`.                                                                                                                                                                                                                |
| poetry-install-args     | Additional args to pass to `poetry install`. Defaults to `-vvv --remove-untracked`                                                                                                                                                                                                                         |
| poetry-install-cmd      | Command for installing poetry project. Can be used to provide a custom install command. The value of `poetry-install-args` is appended after this. Defaults to `poetry install`. This is also a check for the existence of a `Makefile` with a `setup-poetry` target. If found, using it takes precedence. |
| poetry-preview          | Allow install of prerelease versions of Poetry.                                                                                                                                                                                                                                                            |
| poetry-version          | Poetry version to use. If version is not provided then latest stable version will be used. Should be provided as a version specifier that can be passed to [pipx](https://github.com/pypa/pipx) or `latest`                                                                                                |
| python-version          | Version range or exact version of a Python version to use, using semver version range syntax. Reads from `pyproject.toml` if unset.                                                                                                                                                                        |
| python-version-file     | File containing the Python version to use.                                                                                                                                                                                                                                                                 |
| token                   | Used to pull python distributions from actions/python-versions. Since there's a default, this is typically not supplied by the user.                                                                                                                                                                       |

### Outputs

| Key            | Description                                                               |
| -------------- | ------------------------------------------------------------------------- |
| cache-hit      | Whether there was a cache hit for the Python virtual environment.         |
| python-path    | The absolute path to the Python or PyPy executable.                       |
| python-version | The installed Python version. Useful when given a version range as input. |

[pipx]: https://github.com/pypa/pipx
[poetry]: https://github.com/python-poetry/poetry
