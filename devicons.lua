-- mod-version:3
-- Author: PerilousBooklet (forked from Jipok's nonicons.lua)
-- Doesn't work well with scaling mode == "ui"

local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local TreeView = require "plugins.treeview"
local Node = require "core.node"

-- Config
config.plugins.devicons = common.merge({
  use_default_dir_icons = false,
  use_default_chevrons = false,
  draw_treeview_icons = true,
  draw_tab_icons = true,
  -- The config specification used by the settings gui
  config_spec = {
    name = "Devicons",
    {
      label = "Use Default Directory Icons",
      description = "When enabled does not use nonicon directory icons.",
      path = "use_default_dir_icons",
      type = "toggle",
      default = false
    },
    {
      label = "Use Default Chevrons",
      description = "When enabled does not use nonicon expand/collapse arrow icons.",
      path = "use_default_chevrons",
      type = "toggle",
      default = false
    },
    {
      label = "Draw Treeview Icons",
      description = "Enables file related icons on the treeview.",
      path = "draw_treeview_icons",
      type = "toggle",
      default = true
    },
    {
      label = "Draw Tab Icons",
      description = "Adds file related icons to tabs.",
      path = "draw_tab_icons",
      type = "toggle",
      default = true
    }
  }
}, config.plugins.devicons)

local icon_font = renderer.font.load(USERDIR.."/fonts/font_devicons/devicons.ttf", 15 * SCALE)
local chevron_width = icon_font:get_width("") -- ?
local previous_scale = SCALE

local extension_icons = {
  -- Arduino
  [".ino"] = {"#008184", ""},
  -- Assembly
  [".asm"] = {"#DE002D", ""},
  -- C
  [".c"] = { "#599eff", "" }, 
  [".cc"] = { "#599eff", "" }, 
  [".h"] = { "#599eff", "" },
  -- Cobol
  [".cbl"] = { "#005CA5", "" }, 
  [".cob"] = { "#005CA5", "" }, 
  [".cpy"] = { "#005CA5", "" },
  -- Clojure
  [".clj"] = {"#91DC47", ""}, 
  [".cljc"] = {"#91DC47", ""}, 
  [".cljs"] = {"#91DC47", ""},
  -- ?
  [".conf"] = { "#6d8086", "" }, 
  [".cfg"] = { "#6d8086", "" },
  -- C++
  [".cpp"] = { "#519aba", "" },
  -- Crystal
  [".cr"] = { "#000000", "" },
  -- C#
  [".cs"] = { "#596706", "" },
  -- CSS
  [".css"] = { "#563d7c", "" }, 
  [".module.css"] = { "#563d7c", "" },
  [".sass"] = {"#CF649A", ""},
  [".scss"] = {"#CF649A", ""},
  -- D
  [".d"] = {"#B03931", ""}, 
  [".di"] = {"#B03931", ""},
  
  -- Dart
  [".dart"] = {"#055A9C", ""},
  -- diff
  [".diff"] = { "#41535b", "" },
  -- Elm
  [".elm"] = { "#519aba", "" },
  -- Erlang
  [".erl"] = { "#A90533", "" }, 
  [".hrl"] = { "#A90533", "" },
  -- Elixir
  [".ex"] = { "#a074c4", "" }, 
  [".exs"] = { "#a074c4", "" },
  -- F#
  [".fs"] = { "#34B9D9", "" }, 
  [".fsi"] = { "#34B9D9", "" }, 
  [".fsx"] = { "#34B9D9", "" }, 
  [".fsscript"] = { "#34B9D9", "" },
  -- Fortran
  [".f"] = {"#734796", ""},
  [".F"] = {"#734796", ""},
  [".f90"] = {"#734796", ""},
  [".f95"] = {"#734796", ""},
  [".f03"] = {"#734796", ""},
  -- Godot
  [".gd"] = { "#478CBF", "" },
  -- Go
  [".go"] = { "#519aba", "" },
  -- Groovy
  [".groovy"] = {"#357A93", ""}, 
  [".gvy"] = {"#357A93", ""}, 
  [".gy"] = {"#357A93", ""}, 
  [".gsh"] = {"#357A93", ""},
  -- Haskell
  [".hs"] = {"#5E5086", ""},
  -- HTML
  [".html"] = { "#e34c26", "" }, 
  [".html.erb"] = { "#e34c26", "" },
  -- WIP: J
  -- [".j2"] = { "#02D0FF", "" },
  -- Java
  [".java"] = { "#cc3e44", "" },
  -- Julia
  [".jl"] = {"#9359A5", ""},
  -- Images
  [".jpg"] = { "#a074c4", "" }, 
  [".png"] = { "#a074c4", "" }, 
  [".svg"] = { "#a074c4", "" },
  -- WIP: Archive files
  -- [".zip"] = { "", "" }, 
  -- [".gzip"] = { "", "" },
  -- [".tar"] = { "", "" }, 
  -- [".tar.xz"] = { "", "" }, 
  -- [".tar.gz"] = { "", "" },
  -- [".rar"] = { "", "" },
  -- Javascript
  [".js"] = { "#cbcb41", "" },
  -- JSON
  [".json"] = { "#854CC7", "" },
  -- Kotlin
  [".kt"] = { "#816EE4", "" }, 
  [".kts"] = { "#816EE4", "" },
  -- Lisp
  [".lisp"] = { "#FFFFFF", "" }, 
  [".lsp"] = { "#FFFFFF", "" },
  -- Lua
  [".lua"] = { "#51a0cf", "" },
  -- Lilypond
  [".ly"] = {"#FC7DB0", ""},
  -- Markdown
  [".md"] = { "#519aba", "" },
  -- Ocaml
  [".ml"] = { "#EE750A", "" },
  -- Nim
  [".nim"] = { "#FFE953", "" }, 
  [".nims"] = { "#FFE953", "" }, 
  [".nimble"] = { "#FFE953", "" },
  -- Nix
  [".nix"] = {"#7EB3DF", ""},
  -- Odin
  [".odin"] = { "#3882D2", "" },
  -- Perl
  [".pl"] = { "#519aba", "" }, 
  [".pm"] = { "#519aba", "" },
  -- PHP
  [".php"] = { "#a074c4", "" },
  -- PlantUML
  [".puml"] = { "#FABD14", "" },
  [".plantuml"] = { "#FABD14", "" },
  [".iuml"] = { "#FABD14", "" },
  [".pu"] = { "#FABD14", "" },
  [".wsd"] = { "#FABD14", "" },
  -- Python
  [".py"] = { "#3572A5", "" }, 
  [".pyc"] = { "#519aba", "" }, 
  [".pyd"] = { "#519aba", "" },
  [".rpy"] = { "#3572A5", "" }, 
  [".rpyc"] = { "#519aba", "" },
  -- R
  [".r"] = { "#358a5b", "" }, 
  [".R"] = { "#358a5b", "" },
  -- Rake
  [".rake"] = { "#701516", "" },
  -- Ruby
  [".rb"] = { "#701516", "" },
  -- Rust
  [".rs"] = { "#dea584", "" },
  -- RSS
  [".rss"] = { "#cc3e44", "" },
  -- OpenSCAD
  [".scad"] = {"#e8b829", ""},
  -- Scala
  [".scala"] = { "#cc3e44", "" },
  -- Shell
  [".sh"] = { "#4d5a5e", "" },
  [".bash"] = { "#4169e1", "" },
  [".bat"] = { "#4169e1", "" },
  [".ps1"] = { "#4169e1", "" },
  [".fish"] = { "#ca2c92", "" },
  -- SQL
  [".sql"] = { "#C84431", "" },
  -- Svelte
  [".svelte"] = {"#FF3C00", ""},
  -- Swift
  [".swift"] = { "#e37933", "" },
  -- System Verilog
  [".sv"] = { "#1A348F", "" }, 
  [".svh"] = { "#1A348F", "" },
  -- TOMl
  [".toml"] = { "#6d8086", "" },
  -- Typescript
  [".ts"] = { "#519aba", "" },
  -- V
  [".v"] = { "#536B88", "" }, [".vsh"] = { "#536B88", "" },
  -- Vala
  [".vala"] = { "#706296", "" },
  -- WIP: Verilog
  -- FIX: the .v extension for Verilog conflicts with the one for the V language
  -- [".v"] = { "", "" },
  -- WIP: Visual Basic Scripting Edition
  -- [".vbs"] = { "", "" },
  -- Vim
  [".vim"] = { "#8f00ff", "" },
  -- Visual Basic
  [".vb"] = { "#1A5F94", "" },
  [".vbs"] = { "#1A5F94", "" },
  -- WebAssembly
  [".wasm"] = {"#654EF0", ""},
  -- XML
  [".xml"] = {"#005FAD", ""},
  -- YAML
  [".yaml"] = { "#6d8086", "" },
  [".yml"] = { "#6d8086", "" },
  -- Zig
  [".zig"] = { "#cbcb41", "" },
  -- Wesnoth Markup Language Language
  [".wfl"] = { "#D29F2C", "" },
  -- WIP: Security Certificate File Format for Windows
  --[".crt"] = { "", "" },
  -- Windows registry
  [".reg"] = { "#52D4FB", "" },
  -- Desktop
  [".desktop"] = { "#6d8086", "" },
  -- INI
  [".ini"] = { "#ffffff", "" },
}

local known_names_icons = {
  -- Alpine.js
  ["alpine.config.js"] = {"#77C1D2", ""},
  -- Angular
  ["angular.json"] = {"#DE002D", ""},
  -- Arch Linux
  ["pkgbuild"] = {"#358fdd", ""},
  -- Babel
  ["babel.config.json"] = {"#F9DC3E", ""},
  [".babelrc.json"] = {"#F9DC3E", ""},
  -- Changelog
  ["changelog"] = { "#657175", "" },
  ["changelog.txt"] = { "#4d5a5e", "" },
  ["changelog.md"] = { "#519aba", "" },
  -- Cmake
  ["Cmakelists.txt"] = { "#0068C7", "" },
  -- Docker
  ["docker-compose.yml"] = { "#4289a1", "" },
  ["dockerfile"] = { "#296478", "" },
  -- Gradle
  ["gradlew"] = { "#6d8086", "" },
  ["gradlew.bat"] = { "#6d8086", "" },
  -- LaTeX
  [".tex"] = {"#467f22", ""},
  [".sty"] = {"#467f22", ""},
  [".cls"] = {"#467f22", ""},
  [".dtx"] = {"#467f22", ""},
  [".ins"] = {"#467f22", ""},
  -- License
  ["license"] = { "#d0bf41", "" },
  ["license.txt"] = { "#d0bf41", "" },
  -- Lite XL
  ["init.lua"] = { "#2d6496", "" },
  -- Make
  ["makefile"] = { "#6d8086", "" },
  -- Meson
  ["meson.build"] = {"#6d8086", ""},
  ["meson_options.txt"] = {"#6d8086", ""},
  -- Next.js
  ["next.config.js"] = {"#000000", ""},
  -- Node.js
  ["package.json"] = {"#68A063", ""},
  -- NPM
  [".npmrc"] = {"#CC3534", ""},
  -- PostCSS
  ["postcss.config.js"] = {"#DD3A0A", ""},
  [".postcssrc"] = {"#DD3A0A", ""},
  -- Prisma
  ["schema.prisma"] = { "#2D3748", "" },
  -- Python
  ["setup.py"] = { "#559dd9", "" },
  -- README
  ["readme.md"] = { "#72b886", "" },
  ["readme"] = { "#72b886", "" },
  -- Svelte
  ["svelte.config.js"] = {"#FF3C00", ""},
  -- Tailwind
  ["tailwind.config.js"] = {"#38BDF8", ""},
  -- Tmux
  [".tmux.conf"] = { "#1BB91F", "" },
  ["tmux.conf"] = { "#1BB91F", "" },
  -- Vue
  ["vue.config.js"] = {"#3FB984", ""},
  -- Zig
  ["build.zig"] = { "#6d8086", "" },
}

-- Preparing colors
for k, v in pairs(extension_icons) do
  v[1] = { common.color(v[1]) }
end
for k, v in pairs(known_names_icons) do
  v[1] = { common.color(v[1]) }
end

-- Override function to change default icons for dirs, special extensions and names
local TreeView_get_item_icon = TreeView.get_item_icon
function TreeView:get_item_icon(item, active, hovered)
  local icon, font, color = TreeView_get_item_icon(self, item, active, hovered)
  if previous_scale ~= SCALE then
    icon_font:set_size(
      icon_font:get_size() * (SCALE / previous_scale)
    )
    chevron_width = icon_font:get_width("") -- ?
    previous_scale = SCALE
  end
  if not config.plugins.devicons.use_default_dir_icons then
    icon = "" -- file icon
    font = icon_font
    color = style.text
    if item.type == "dir" then
      icon = item.expanded and "" or "" -- file dir icon open, file dir icon closed
    end
  end
  if config.plugins.devicons.draw_treeview_icons then
    local custom_icon = known_names_icons[item.name:lower()]
    if custom_icon == nil then
      custom_icon = extension_icons[item.name:match("^.+(%..+)$")]
    end
    if custom_icon ~= nil then
      color = custom_icon[1]
      icon = custom_icon[2]
      font = icon_font
    end
    if active or hovered then
      color = style.accent
    end
  end
  return icon, font, color
end

-- Override function to draw chevrons if setting is disabled
local TreeView_draw_item_chevron = TreeView.draw_item_chevron
function TreeView:draw_item_chevron(item, active, hovered, x, y, w, h)
  if not config.plugins.devicons.use_default_chevrons then
    if item.type == "dir" then
      local chevron_icon = item.expanded and "" or ""  -- open arrow icon, closed arrow icon ?
      local chevron_color = hovered and style.accent or style.text
      common.draw_text(icon_font, chevron_color, chevron_icon, nil, x, y, 0, h)
    end
    return chevron_width + style.padding.x/4
  end
  return TreeView_draw_item_chevron(self, item, active, hovered, x, y, w, h)
end

-- Override function to draw icons in tabs titles if setting is enabled
local Node_draw_tab_title = Node.draw_tab_title
function Node:draw_tab_title(view, font, is_active, is_hovered, x, y, w, h)
  if config.plugins.devicons.draw_tab_icons then
    local padx = chevron_width + style.padding.x/2
    local tx = x + padx -- Space for icon
    w = w - padx
    Node_draw_tab_title(self, view, font, is_active, is_hovered, tx, y, w, h)
    if (view == nil) or (view.doc == nil) then return end
    local item = { type = "file", name = view.doc:get_name() }
    TreeView:draw_item_icon(item, false, is_hovered, x, y, w, h)
  else
    Node_draw_tab_title(self, view, font, is_active, is_hovered, x, y, w, h)
  end
end
