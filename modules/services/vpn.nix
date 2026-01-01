{ config, pkgs, ... }:

{
  # clash-verge; uncomment when not on proxy
  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
  };

  # Global session variables for proxy
  environment.sessionVariables = {
    # proxy settings - adjust port if you changed it in Clash Verge
    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
    all_proxy = "socks5://127.0.0.1:7897";
  };
}

