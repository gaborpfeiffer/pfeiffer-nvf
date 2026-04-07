{ pkgs,lib,... }:

{
  config.vim = {
        viAlias = true;
        vimAlias = true;

        globals.mapleader = " ";

        options = {
          clipboard = "unnamedplus";
          mouse = "a";
          splitbelow = true;
          splitright = true;
          timeoutlen = 500;
          termguicolors = true;
          completeopt = "menuone,noselect";
          updatetime = 300;

          # swap
          swapfile = false;
          backup = false;
          writebackup = false;
          undofile = true;

          # line numbers
          number = true;
          relativenumber = true;
          wrap = false;
          cursorline = true;
          signcolumn = "yes";
          scrolloff = 8;
          sidescrolloff = 5;

          # tab settings
          tabstop = 2;
          shiftwidth = 2;
          softtabstop = 2;
          expandtab = true;
          shiftround = true;
          autoindent = true;
          smartindent = true;
        };

        keymaps = [
          # core
          {
            mode = "n";
            key = "<leader>w";
            action = ":w<CR>";
            silent = false;
          }
          {
            mode = "n";
            key = "<leader>q";
            action = ":q<CR>";
            silent = false;
          }
          # neo-tree
          {
            mode = "n";
            key = "<leader>e";
            action = ":Neotree toggle<CR>";
            silent = true;
          }
          {
            mode = "n";
            key = "<leader>o";
            action = ":Neotree focus<CR>";
            silent = true;
          }
          #telescope
          {
            mode = "n";
            key = "<leader>ff";
            action = "<cmd>Telescope find_files<CR>";
          }
          {
            mode = "n";
            key = "<leader>fg";
            action = "<cmd>Telescope live_grep<CR>";
          }
          {
            mode = "n";
            key = "<leader>fb";
            action = "<cmd>Telescope buffers<CR>";
          }
          {
            mode = "n";
            key = "<leader>fh";
            action = "<cmd>Telescope help_tags<CR>";
          }
          {
            mode = "n";
            key = "<leader>/";
            action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
          }
          #trouble
          {
            mode = "n";
            key = "<leader>xx";
            action = "<cmd>Trouble diagnostics toggle<CR>";
          }
        ];

        # auto complete
        autocomplete = {
          nvim-cmp = {
            enable = true;
          };
        };

        # auto pairs
        autopairs.nvim-autopairs.enable = true;

        #format on save
        autocmds = [
          {
            event = ["BufWritePre"];
            pattern = [
              "*.php"
              "*.ts"
              "*.tsx"
            ];
            callback = lib.generators.mkLuaInline ''
              function()
                require("conform").format({async = false})
                require("lint").try_lint()
              end
            '';
          }
        ];

        # treesitter
        treesitter = {
          enable = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            php
            typescript
            tsx
          ];
        };

        #Diagnostic
        diagnostics = {
          enable = true;
          config = {
            virtual_text = true;
            signs.text = lib.generators.mkLuaInline ''
              {
                [vim.diagnostic.severity.ERROR] = "󰅚 ",
                [vim.diagnostic.severity.WARN] = "󰀪 ",
              }
            '';
          };

          #nvim-lint
          nvim-lint = {
            enable = true;

            linters_by_ft = {
              php = ["phpstan"];
            };
            /*linters = {
              phpstan = {
               append_fname = true;
               args = [
                "analyse"
                "-l 9"
               ];
              };
            };*/
          };
        };

        # LSP config
        lsp = {
          enable = true;
          trouble = {
            enable = true;
          };
        };

        languages = {
          nix.enable = true;
          json.enable = true;

          # typescript
          ts = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            format = {
              enable = true;
            };
          };

          # php
          php = {
            enable = true;
            lsp.enable = true;
            lsp.servers = ["intelephense"];
            treesitter.enable = true;
            format = {
              enable = true;
              type = ["php_cs_fixer"];
            };
          };
        };

        visuals = {
          nvim-web-devicons.enable = true;
          /*indent-blankline = {
            enable = true;
            setupOpts = {
              indent = {
                char = "▏";
                tab_char = "▏";
              };
              scope = {
                enabled = true;
                show_start = true;
                show_end = false;
              };
            };
          };*/
        };


        # Plugins
        filetree.neo-tree = {
          enable = true;
          setupOpts = {
            filesystem = {
              filtered_items = {
                hide_dotfiles = false;
                hide_gitignored = false;
              };
            };
          };
        };


        statusline.lualine = {
          enable = true;
          theme = "tokyonight";
          sectionSeparator = { left = ""; right = ""; };
          componentSeparator = { left = ""; right = ""; };
        };

        telescope = {
          enable = true;
          
          # mappings
          mappings.lspDefinitions = "gd";
          mappings.lspReferences = "gr";

          extensions = [
            {
              name = "fzf";
              packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
              setup = {
                fzf = {
                  fuzzy = true;
                  override_file_sorter = true;
                  override_generic_sorter = true;
                  case_mode = "smart_case";
                };
              };
            }
          ];
          setupOpts = {
            defaults = {
              layout_config.horizontal.prompt_position = "top";
              sorting_strategy = "ascending";
            };
            pickers.find_files.hidden = true;
          };
        };

        terminal.toggleterm = {
          enable = true;
          lazygit = {
            enable = true;
            mappings.open = "<leader>lg";
          };
        };

        git.gitsigns = {
          enable = true;
          setupOpts = {
            attach_to_untracked = true;
            current_line_blame = true;
            current_line_blame_opts = {
              delay = 0;
              virt_text_pos = "eol";
            };
          };
        };

        dashboard.dashboard-nvim = {
          enable = true;
          setupOpts = {
            theme = "doom";
            config = {
              header = [
                "┌───────────────────────────┐"
                "│       Welcome back!!      │"
                "└───────────────────────────┘"
              ];
              center = [
                { icon = " "; desc = "Find file"; key = "f"; action = "Telescope find_files"; }
                { icon = " "; desc = "Live grep"; key = "g"; action = "Telescope live_grep"; }
                { icon = " "; desc = "File tree"; key = "e"; action = "Neotree toggle"; }
                { icon = " "; desc = "Quit"; key = "q"; action = "qa"; }
              ];
              footer = [ "Tip: press ? for which-key" ];
            };
          };
        };

        theme = {
          enable = true;
          name = "tokyonight";
          style = "moon";
        };


      };
}
