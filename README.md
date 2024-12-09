自行打包的 [lazygit](https://github.com/jesseduffield/lazygit)，供 Debian 或其他发行版上使用。

Self-packaged [lazygit](https://github.com/jesseduffield/lazygit) for use on Debian or other distro.


## Usage/用法

```sh
echo "deb [trusted=yes] https://github.com/wcbing-build/lazygit-debs/releases/latest/download ./" |
    sudo tee /etc/apt/sources.list.d/lazygit.list
sudo apt update
```