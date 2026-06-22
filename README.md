# My Neovim Configuration

Personal Neovim configuration files with a focus on usability and efficiency.

> [!TIP] Try [ghgrab](https://github.com/abhixdd/ghgrab) what you want!

> [!INFO] LSP servers are copied from [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

If you cannot understand *how-to-install*, just

```sh
mv ~/.config/nvim ~/.config/nvim.backup && git clone https://github.com/jvkceberg/neovim-config.git ~/.config/nvim
```

---

## Why Neovim?

Modern code editors has powerful features for developers. But they often struggle with:

- Memory usage
- Latency
- Limited extensibility

for example:

[VSCode](https://code.visualstudio.com/) uses Electron, which makes it heavy and slow.
[Zed](https://zed.dev/) is so strong, but highly frustrated me for [**unsupportive of server using old filesystem**](https://github.com/zed-industries/zed/discussions/54150)

Neovim, was best-fit to me.

---

### But still,

Strange quirk of some developers is that they worship vim editors for **blazing speed**.I don't hope someone to think as that.

Most of development time is filled with **thinking**, not *typing*. Neovim is fast, but it's not about development speed.
