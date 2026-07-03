-- Use zsh as the shell for :terminal, :!, and toggleterm.
return {
  "AstroNvim/astrocore",
  opts = {
    options = {
      opt = {
        shell = "/usr/bin/zsh",
        shellcmdflag = "-c",
      },
    },
  },
}
