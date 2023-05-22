<div align="center">

![zap_logo](https://user-images.githubusercontent.com/29136904/202043505-8fda8d1e-3669-463b-a0c9-38c367ffb753.png)

</div>

---

<div align="center">

<p>
    <a href="https://github.com/zap-zsh/zap/releases/latest">
      <img alt="Latest release" src="https://img.shields.io/github/v/release/zap-zsh/zap?style=for-the-badge&logo=starship&color=C9CBFF&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/zap-zsh/zap/pulse">
      <img alt="Last commit" src="https://img.shields.io/github/last-commit/zap-zsh/zap?style=for-the-badge&logo=starship&color=8bd5ca&logoColor=D9E0EE&labelColor=302D41"/>
    </a>
    <a href="https://github.com/zap-zsh/zap/blob/master/LICENSE">
      <img alt="License" src="https://img.shields.io/github/license/zap-zsh/zap?style=for-the-badge&logo=starship&color=ee999f&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/zap-zsh/zap/stargazers">
      <img alt="Stars" src="https://img.shields.io/github/stars/zap-zsh/zap?style=for-the-badge&logo=starship&color=c69ff5&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/zap-zsh/zap/issues">
      <img alt="Issues" src="https://img.shields.io/github/issues/zap-zsh/zap?style=for-the-badge&logo=bilibili&color=F5E0DC&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://github.com/zap-zsh/zap">
      <img alt="Repo Size" src="https://img.shields.io/github/repo-size/zap-zsh/zap?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://patreon.com/chrisatmachine" title="Donate to this project using Patreon">
      <img alt="Patreon donate button" src="https://img.shields.io/badge/patreon-donate-yellow.svg?style=for-the-badge&logo=starship&color=f5a97f&logoColor=D9E0EE&labelColor=302D41" />
    </a>
    <a href="https://twitter.com/intent/follow?screen_name=chrisatmachine">
      <img alt="follow on Twitter" src="https://img.shields.io/twitter/follow/chrisatmachine?style=for-the-badge&logo=twitter&color=8aadf3&logoColor=D9E0EE&labelColor=302D41" />
    </a>

:zap: Zap is a minimal `zsh` plugin manager

</div>

## Prerequisites

- [ZSH](https://www.zsh.org/)
- a nerd font (optional)

To get your nerd font check out [getNF](https://github.com/ronniedroid/getnf) project or visit [NerdFonts](https://www.nerdfonts.com/) site.

## Install

```zsh
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
```

**Zap works on Linux, macOS, Windows (within WSL), Android (within Termux)**

## Example usage

Add the following to your `.zshrc`

```zsh
# Example install of plugins
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"

# Example install of a plugin pinned to specifc commit or branch, just pass the git reference
plug "zsh-users/zsh-syntax-highlighting" "122dc46"

# Example install of a theme
plug "zap-zsh/zap-prompt"

# Example install of a zsh completion
plug "esc/conda-zsh-completion"
```

You can also use `Zap` to install custom plugins or source custom files present on your local filesystem. A file descriptor which points to a directory is treated as a plugin, versus a regular file. For example:

```zsh
# Example install of a local plugin
plug "$HOME/plugins/my-custom-prompt"

# Example sourcing of local files
plug "$HOME/.config/zsh/aliases.zsh"
plug "$HOME/.config/zsh/exports.zsh"
```

By default `Zap` when installing a plugin will clone a GitHub repository using a HTTPS web URL, if you require to be able to install from a private GitHub or from a different git server (for example GitLab) you can provide a different URL prefix to be used. For example:

```zsh
# Example globally setting the prefix for Zap to git clone using an SSH key
export ZAP_GIT_PREFIX="git@github.com:"
plug "zap-zsh/private-repo"

# Example git clone using GitLab for a single plugin
ZAP_GIT_PREFIX="https://gitlab.com/" plug "user/repo"
```

It is possible to call `plug` in any interactive shell session to source a file or to download and source a plugin for that particular session.

:warning: If you call `plug` outside your `.zshrc` file, the plugin you sourced will not be sourced at the next shell reload.

## Commands

Zap provided commands for updating and cleaning up plugins

- To update plugins or Zap:

  ```zsh
  zap update self # Update the Zap installation
  zap update plugins # Update all your plugins but not Zap
  zap update all # Update both the Zap installation and its plugins
  ```

- To list all plugins you are using:

  ```zsh
  zap list
  ```

- To remove plugins you are no longer using:

  ```zsh
  zap clean
  ```

## Uninstall

To uninstall Zap, when currently active, execute the following:

```zsh
rm -rf "$ZAP_DIR"
```

When not currently active, execute the following:

```zsh
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/zap"
```

## Notes

For sourcing local files use `$HOME` instead of `~` when giving a full path to the file.

---

[![zap thumbnail](https://user-images.githubusercontent.com/29136904/238183118-943e3f25-5198-45a5-a22e-45a3a27db11d.png)](https://www.youtube.com/watch?v=LhDMw6n3GI4)

<!----------------------------------------------------------------------------->

<div align="center">

## Socials

<p align="center">
<a href="https://github.com/zap-zsh"><img src="https://user-images.githubusercontent.com/696094/196835284-c52d4bd1-7034-439e-848b-47d4f2933dff.svg" width="64" height="64" alt="Github Logo"/></a> <img src="assets/misc/transparent.png" height="1" width="5"/> <a href="https://discord.gg/Xb9B4Ny"><img src="https://user-images.githubusercontent.com/696094/196835282-f5c47d66-29b7-4210-9ee0-d9cdecde3559.svg" width="64" height="64" alt="Discord Logo"/></a> <img src="assets/misc/transparent.png" height="1" width="5"/> <a href="https://twitter.com/chrisatmachine"><img src="https://user-images.githubusercontent.com/696094/196835281-52617611-ede6-40da-a4bc-8c5025622bbf.svg" width="64" height="64" alt="Twitter Logo"/></a> <img src="assets/misc/transparent.png" height="1" width="5"/> <a href="https://reddit.com/r/zapzsh"><img src="https://user-images.githubusercontent.com/696094/196835278-041a4f99-28e1-4a93-8e35-c8912f1089fc.svg" width="64" height="64" alt="Reddit Logo"/></a>
</p>

## Thanks to all contributors

<a href="https://github.com/zap-zsh/zap/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=zap-zsh/zap" />
</a>

</div>
