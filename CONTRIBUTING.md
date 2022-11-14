# Contributing to Zap

Welcome to the Zap contributing guide.

## Development & CI

Auto formatted code with [`shfmt`](https://github.com/mvdan/sh#shfmt) is required for a pull request to be merged.

Format code:

```bash
shfmt -l -w .
```

### pre-commit

To add a formatting check on each commit [pre-commit](https://pre-commit.com/#intro) can be used.
shfmt via Go is required for pre-commit to work.

Install `pre-commit`:

```bash
pip install pre-commit
pre-commit install
```
