# My neovim configuration

This repository contains my neovim configuration. It was originally based on
[Launch.nvim](https://github.com/LunarVim/Launch.nvim), updated along the way
adding plugins and configurations the way I prefer them, but recently rebased
to start from [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)
with all of my configuration changes added, while leaving much of the base
intact as it was more functional for what I was looking for and easier than
attempting to integrate the things I liked about Kickstart.nvim back into my
original config.

I've left the original Kickstart.nvim README in here for reference as the 
information it provides is still applicable and invaluable.

### Additions/Updates made:
- Split config from single file out into multiple files, mainly plugins, but
saved some parts of Launch.nvim's structure or portions of config that I liked
- Added personal preferred extra plugins on-top of what Kickstart.nvim provides
- gitsigns.nvim is not the configuration provided by Kickstart (one of the
optional included plugins), but the one I've been using from Launch.nvim.

### Extra Plugins List:
- [breadcrumbs.nvim](https://github.com/LunarVim/breadcrumbs.nvim)
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [colorizer.lua](https://github.com/NvChad/nvim-colorizer.lua)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [nvim-navic](https://github.com/SmiteshP/nvim-navic)
- [nvim-surround](https://github.com/kylechui/nvim-surround)
- [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua)
- [telekasten.nvim](https://github.com/renerocksai/telekasten.nvim)
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)

## Thanks
Huge thanks to the entire Neovim community for providing amazing plugins and
sharing information about configurations.

Special thanks to [Chris@Machine](https://chrisatmachine.com/), creator of
LunarVim and many plugins and other things including Launch.nvim and it's
predecessor (which I actually used originally) [Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch),
and [TJ DeVries](https://github.com/tjdevries), creator of Kickstart.nvim,
Telescope.nvim, plenary.nvim, and many many more projects that are used by 
everyone in the community, as well as providing amazing learning content
for Neovim, it's configuration, Lua, and more.
