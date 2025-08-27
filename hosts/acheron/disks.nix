{
  inputs,
  lib,
  ...
}: let
  # ls -l /dev/disk/by-id | grep <disk>
  device = "/dev/disk/by-id/nvme-CT1000P2SSD8_2130E5BB2322";
  root = "${device}-part2";
in {
  imports = [inputs.disko.nixosModules.default];

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir -p /btrfs_tmp
    mount "${root}" /btrfs_tmp

    mkdir -p /btrfs_tmp/roots

    if [[ -d /btrfs_tmp/roots/root ]]; then
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/roots/root)" "+%Y-%m-%d_%H:%M:%S")
        mv /btrfs_tmp/roots/root "/btrfs_tmp/roots/root-$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'

        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done

        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/roots/ -maxdepth 1 -name "root-*" -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/roots/root

    umount /btrfs_tmp
  '';

  fileSystems = {
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          esp = {
            name = "esp";
            type = "EF00";

            start = "1M";
            size = "1G";

            priority = 1;

            content = {
              type = "filesystem";
              format = "vfat";

              extraArgs = ["-nBOOT"];

              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          root = {
            start = "1025MiB";
            end = "-16G";

            priority = 2;

            content = {
              type = "btrfs";

              extraArgs = ["-f" "-LNIXOS"];

              subvolumes = {
                "/roots/root" = {
                  mountpoint = "/";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = ["compress=zstd" "noatime"];
                };
              };
            };
          };

          swap = {
            name = "swap";
            type = "8200";

            start = "-16G";
            size = "16G";

            priority = 3;

            content = {
              type = "swap";

              resumeDevice = true;
              discardPolicy = "once";

              extraArgs = ["-LSWAP"];
            };
          };
        };
      };
    };
  };
}
