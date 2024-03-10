# azure-cli.nvim

A Neovim plugin that serves as a wrapper for executing Azure CLI commands
directly within the editor.

## Features

- **Execute Azure CLI commands**: Seamlessly run Azure CLI commands from within
  Neovim.
- **Improved Workflow**: Enhance productivity by accessing Azure CLI
  functionality directly in your editor.

## Installation

Use `lazy.nvim` for lazy loading of this plugin in your Neovim configuration.

### [lazy.nvim](https://github.com/folke/lazy.nvim)

Add the following line to your `lazy.nvim` configuration file:

```lua
{
  "dannicholls/azure-cli.nvim",
  lazy = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
},
```

Then, use the `Lazy reload` command to reload your Neovim configuration.

## Usage

TODO: Add usage instructions here.

## Configuration

You can add these keybinding to your `whichkey` configuration:

```lua
M.AzureCli = {
  n = {
    ["<leader>aa"] = { ":AzureCli<CR>", opts = { nowait = true } },
    ["<leader>ad"] = { ":AzureCliDefect<CR>", opts = { nowait = true } },
    ["<leader>ab"] = { ":AzureCliBugs<CR>", opts = { nowait = true } },
    ["<leader>as"] = { ":AzureCliUserStories<CR>", opts = { nowait = true } },
    ["<leader>at"] = { ":AzureCliTasks<CR>", opts = { nowait = true } },
    ["<leader>ai"] = { ":AzureCliIssues<CR>", opts = { nowait = true } },
  },
}
```

## Contributing

Contributions are welcome! Please read the
[contribution guidelines](CONTRIBUTING.md) before getting started.

## License

This project is licensed under the [MIT License](LICENSE).

## References

- [WIQL Query Syntax](https://learn.microsoft.com/en-us/azure/devops/boards/queries/wiql-syntax?view=azure-devops)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/boards?view=azure-cli-latest)
