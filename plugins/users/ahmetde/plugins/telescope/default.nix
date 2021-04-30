{ config, pkgs, lib, ... }:
let
  readFile = file: ext: builtins.readFile (./. + "/${file}.${ext}");
  readVimSection = file: (readFile file "vim");
  readLuaSection = file: wrapLuaConfig (readFile file "lua");

  # For plugins configured with lua
  wrapLuaConfig = luaConfig: ''
    lua<<EOF
    ${luaConfig}
    EOF
  '';
  pluginWithLua = plugin: {
    inherit plugin;
    config = readLuaSection plugin.pname;
  };
  pluginWithCfg = plugin: {
    inherit plugin;
    config = readVimSection plugin.pname;
  };
in
{
  programs.neovim = {
    plugins = with pkgs.nixos-unstable.vimPlugins; [
      telescope-z-nvim
      telescope-symbols-nvim
      (pluginWithCfg telescope-nvim)
      telescope-fzy-native-nvim
      telescope-fzf-writer-nvim
      telescope-frecency-nvim
      popup-nvim
      plenary-nvim
    ];
  };
}
