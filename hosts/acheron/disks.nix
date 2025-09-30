{
  inputs,
  lib,
  ...
}: let
  # ls -l /dev/disk/by-id | grep <disk-label>
  device = "/dev/disk/by-id/nvme-CT1000P2SSD8_2130E5BB2322";
  root = "${device}-part2";
in {
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir -p /mnt
    mount "${root}" /mnt

    mkdir -p /mnt/roots

    if [[ -d /mnt/roots/root ]]; then
        lastRoot=$(ls /mnt/roots/ | grep -E '^root-[0-9]+$' | sed 's/root-//' | sort -n | tail -1)

        if [[ -z "$lastRoot" ]]; then
            lastRoot=0
        fi

        newRoot=$((lastRoot + 1))

        mv /mnt/roots/root "/mnt/roots/root-$newRoot"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'

        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/mnt/$i"
        done

        btrfs subvolume delete "$1"
    }

    for old in $(ls /mnt/roots/ | grep -E '^root-[0-9]+$' | sed 's/root-//' | sort -n | head -n -30); do
        delete_subvolume_recursively "/mnt/roots/root-$old"
    done

    btrfs subvolume create /mnt/roots/root

    umount /mnt
  '';

  fileSystems = {
    "/nix".neededForBoot = true;
    "/nix/persist".neededForBoot = true;
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
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/nix/persist" = {
                  mountpoint = "/nix/persist";
                  mountOptions = ["compress=zstd" "noatime"];
                };
                "/home" = {
                  mountpoint = "/home";
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
