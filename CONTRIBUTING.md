# Contributing to Zap

Welcome to the Zap contributing guide.

## Development & CI

Auto formatted code with [`beautysh`](https://github.com/lovesegfault/beautysh) is required for a pull request to be merged.

Format code:

```bash
beautysh ./*.zsh
```

### pre-commit

To add a formatting check on each commit [pre-commit](https://pre-commit.com/#intro) can be used.

Install `pre-commit`:

```bash
pip install pre-commit
pre-commit install
```
