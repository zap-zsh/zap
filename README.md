
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

## Install

```sh
sh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh)
```
    
To install a specific branch of a plugin, you can pass the `--branch` flag to the install.sh script, followed by the name of the branch you want to install:

```sh
sh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.sh) --branch release-0.1
```

## Example usage

Add the following to your `.zshrc`

```sh
# Example install plugins
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"

# Example theme
plug "zap-zsh/zap-prompt"

# Example install completion
plug "esc/conda-zsh-completion"
```

## Commands

Zap provided commands for updating and cleaning up plugins

- To update plugins or Zap:

  ```sh
  zap --update
  ```

- To remove plugins you are no longer using:

  ```sh
  zap --clean
  ```

## Uninstall

```sh
rm -rf ~/.local/share/zap
```

## Notes

Will only work with plugins that are named conventionally, this means that the plugin file is the same name as the repository with the following extensions:

- `.plugin.zsh`
- `.zsh`
- `.zsh-theme`

For example: [vim](https://github.com/zap-zsh/vim)

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
