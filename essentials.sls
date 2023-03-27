# This Salt State is only valid across Debian 11 systems!
install_tailscale_repo:
  cmd.run:
    - name: |
        'curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null'
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg
    - aptkey: false

update_packages:
  cmd.run:
    - name: 'apt-get update -y && apt-get upgrade -y'

install_pkgs:
  pkg.installed:
    - pkgs:
      - tailscale
      - curl
      - htop
      - build-essential
      - pkg-config
      - libssl-dev
      - gnupg