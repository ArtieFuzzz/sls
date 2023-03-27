# Install Tailscale Key & Repo
{% if grains['osfinger'] == 'Debian-11' %}
install_tailscale_repo:
  cmd.run:
    - name: 'curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null'
    - failhard: true
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg
    - aptkey: false
    - failhard: true

{% elif grains['osfinger'] == 'Ubuntu-22.04' %}
install_tailscale_repo:
  cmd.run:
    - name: 'curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null'
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg
    - aptkey: false
    - failhard: true

{% elif grains['osfinger'] == 'Ubuntu-21.10' %}
install_tailscale_repo:
  cmd.run:
    - name: 'curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/impish.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null'
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu impish main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/ubuntu/impish.noarmor.gpg
    - aptkey: false
    - failhard: true

{% else %}
  'This OS is not supported'
{% endif %}


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