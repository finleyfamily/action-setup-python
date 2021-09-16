# action-setup-python

A composite GitHub Action that sets up both Python and poetry with virtual environment caching in a single step.

This Action was started because I found myself repeating the same steps over and over again across jobs.
Since Actions don't currently support YAML anchors, this was my next best option.

> **\[DISCLAIMER\]** This Action can and will undergo breaking changes until there is a v1.0.0.
> There are a few features still lacking from the newly release composite Actions that are needed to improve functionality.
> The primary feature being support for conditions.

<!-- mdformat-toc start --slug=github --no-anchors --maxlevel=6 --minlevel=2 -->

- [Requirements](#requirements)
- [Usage](#usage)
  - [Inputs](#inputs)
  - [Outputs](#outputs)

<!-- mdformat-toc end -->

## Requirements

- [actions/checkout](https://github.com/actions/checkout) needs to be run before this Action
- the virtual environment needs to be created within the project for it to be cached (`poetry config --local virtualenvs.in-project true`)

## Usage

```yaml
steps:
  - uses: actions/checkout@v2
  - uses: ITProKyle/action-setup-python # it is HIGHLY recommended to pin this to a release
    with:
      python-version: 3.9
```

### Inputs

| Key            | Description                                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| architecture   | The target architecture (x86, x64) of the Python interpreter.The target architecture (x86, x64) of the Python interpreter.           |
| poetry-preview | Allow install of prerelease versions of Poetry.                                                                                      |
| poetry-version | Poetry version to use. If version is not provided then latest stable version will be used.                                           |
| python-version | Version range or exact version of a Python version to use, using semver version range syntax.                                        |
| token          | Used to pull python distributions from actions/python-versions. Since there's a default, this is typically not supplied by the user. |

### Outputs

| Key            | Description                                                               |
| -------------- | ------------------------------------------------------------------------- |
| cache-hit      | Whether there was a cache hit for the Python virtual environment.         |
| python-version | The installed Python version. Useful when given a version range as input. |
