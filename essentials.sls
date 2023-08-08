############################################
# Install Essential Packages
#
# This installs:
# - Tailscale | Remote Access
# - Fluent-Bit | Logging & Metrics processing
# - Essential packages
############################################

# Install Tailscale Key & Repo
# Install Fluent-bit key & Repo
{% if grains['osfinger'] == 'Debian-11' %}
install_tailscale_repo:
  cmd.run:
    - name: curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    - failhard: true
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/debian/bullseye.noarmor.gpg
    - aptkey: false
    - failhard: true

install_fluentbit_repo:
  cmd.run:
    - name: curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor > /usr/share/keyrings/fluentbit-keyring.gpg
    - failhard: true
  pkgrepo.managed:
    - humanname: Fluent Bit
    - name: deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/debian/bullseye bullseye main
    - file: /etc/apt/sources.list.d/fluentbit.list
    - key_url: https://packages.fluentbit.io/fluentbit.key
    - gpgcheck: 1
    - aptkey: false
    - failhard: true

{% elif grains['osfinger'] == 'Ubuntu-22.04' %}
install_tailscale_repo:
  cmd.run:
    - name: curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu jammy main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg
    - aptkey: false
    - failhard: true

install_fluentbit_repo:
  cmd.run:
    - name: curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor > /usr/share/keyrings/fluentbit-keyring.gpg
    - failhard: true
  pkgrepo.managed:
    - humanname: Fluent Bit
    - name: deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/ubuntu/jammy jammy main
    - file: /etc/apt/sources.list.d/fluentbit.list
    - key_url: https://packages.fluentbit.io/fluentbit.key
    - gpgcheck: 1
    - aptkey: false
    - failhard: true

{% elif grains['osfinger'] == 'Ubuntu-21.10' %}
install_tailscale_repo:
  cmd.run:
    - name: curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/impish.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
  pkgrepo.managed:
    - humanname: Tailscale
    - name: deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/ubuntu impish main
    - file: /etc/apt/sources.list.d/tailscale.list
    - gpgcheck: 1
    - key_url: https://pkgs.tailscale.com/stable/ubuntu/impish.noarmor.gpg
    - aptkey: false
    - failhard: true

install_fluentbit_repo:
  cmd.run:
    - name: curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor > /usr/share/keyrings/fluentbit-keyring.gpg
    - failhard: true
  pkgrepo.managed:
    - humanname: Fluent Bit
    - name: deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/ubuntu/impish impish main
    - file: /etc/apt/sources.list.d/fluentbit.list
    - key_url: https://packages.fluentbit.io/fluentbit.key
    - gpgcheck: 1
    - aptkey: false
    - failhard: true

{% else %}
  This OS is not supported
{% endif %}

update_packages:
  cmd.run:
    - name: apt-get update -y && apt-get upgrade -y

install_pkgs:
  pkg.installed:
    - pkgs:
      - tailscale
      - vim
      - fluent-bit
      - curl
      - build-essential
      - pkg-config
      - libssl-dev
      - gnupg
      - ca-certificates

install_btop:
  cmd.run:
    - cwd: /tmp
    - name: | 
      wget https://github.com/aristocratos/btop/releases/download/v1.2.13/btop-x86_64-linux-musl.tbz && tar -xvjf btop-x86_64-linux-musl.tbz
      cd btop
      make install
    - unless: 'which btop'

start_fluentbit:
  service.running:
    - name: fluent-bit
    - enable: true
