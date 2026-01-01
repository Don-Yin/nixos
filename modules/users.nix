{ config, pkgs, ... }:

{
  users.users.honor = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # 'wheel' allows sudo

    packages = with pkgs; [
      tree
    ];

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDi6sX2p7xy+ve5YiAZBpcsbaiwuFxV10HUl+kqIaoV7gBdzjR+hh23uPMbXxp2DY6h3TFGLWNv0eebYsLtjmUJh1IGkmSGzEm4VaCkiF/nHPzWzkqZpDD8jHT2N6e4YIGcmVCfeR1YMNJVRI+7AqrrqRGdVNMMk5m1L1Q1plK82p7Wfn6ts3EkNz0WfAA6LkYnELZpMH4ceg+GgoPijyTq1IAK8AM9Sm43j/nenk2+VRTn7Ztliyezo46RWSUSTQi6M7Zg9+SxxKXDNR/OmpIDi1WGxmhQ92Z0HMnpWVeTNc8ZRcphJxKozMB/By9/dPO4Al8Xe66NSlhxnKv8pATTMP2VUCswK8VsD5PBhdADZjdY9fCc8MKT5KFfjto9epdCYbMUx/bTCHNUGf/QIbbn2gNjFjZxWsQjqPdax4p44tmmgVVzBd6e4cRqLJCgl16y47K+TwQ6cZaYd1wyzn3vxWFexPgUJVP2u1MQmvqzQeiEJWjgdl2PluQCjBGVHz2MRpVDmKWL+ar8V3PcG+NVFlI8/yCtejvpyCxIjCEkX8Sr0CoV+9r/6AUlfXo1h2/rHDWWHe0zCdj39QkEGq2fN7/Nb9VJuq59tyV33Wj6zohGXG8mFmjY7kRKHFjyrcbT9fQ4D0krPUa0MRTuvtcQoP5VNb+rHYeeTGwtMRlRJQ== donyin@Dons-MacBook-Air.local"
    ];
  };
}

