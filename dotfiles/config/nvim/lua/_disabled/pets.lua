return {
  {
    "giusgad/pets.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "edluffy/hologram.nvim"
    },
    cmd = {
      "PetsNew",
      "PetsNewCustom",
      "PetsList",
      "PetsKill",
      "PetsKillAll",
      "PetsPauseToggle",
      "PetsHideToggle",
      "PetsSleepToggle",
    },
    init = function()
      vim.api.nvim_create_user_command("PetsAuto", function()
        vim.cmd("PetsNew " .. os.time(os.date("!*t")))
      end, {
        nargs = 0
      })
    end,
    config = true
    -- config = function(_, opts)
    --   require("pets").setup(opts)
    -- end
  }
}
