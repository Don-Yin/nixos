{ config, lib, pkgs, ... }:

let
  cfg = config.services.china-vpn;
in
{
  options.services.china-vpn = {
    enable = lib.mkEnableOption "China VPN (Clash Verge) + China-specific network tweaks (DNS + Nix mirror)";

    httpProxy = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:7897";
      description = "Value for http_proxy.";
    };

    httpsProxy = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1:7897";
      description = "Value for https_proxy.";
    };

    allProxy = lib.mkOption {
      type = lib.types.str;
      default = "socks5://127.0.0.1:7897";
      description = "Value for all_proxy.";
    };

    nameservers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "114.114.114.114" "223.5.5.5" ];
      description = "DNS servers to set when China VPN is enabled.";
    };

    extraSubstituters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
      description = "Extra Nix substituters to prepend when China VPN is enabled.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.clash-verge = {
      enable = true;
      package = pkgs.clash-verge-rev;
    };

    # Global session variables for proxy
    environment.sessionVariables = {
      http_proxy = cfg.httpProxy;
      https_proxy = cfg.httpsProxy;
      all_proxy = cfg.allProxy;
    };

    # China-specific tweaks (only applied when enabled)
    networking.nameservers = cfg.nameservers;
    nix.settings.substituters = lib.mkBefore cfg.extraSubstituters;
  };
}


