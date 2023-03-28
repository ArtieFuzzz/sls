# Install Tailscale Key & Repo
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

install_erlang:
  cmd.run:
    - name: |
        wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb --output /tmp/erlang.deb
        sudo dpkg -i /tmp/erlang.deb
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

{% else %}
  This OS is not supported
{% endif %}


update_packages:
  cmd.run:
    - name: apt-get update -y && apt-get upgrade -y

install_rust:
  cmd.run:
    - name:
      - curl https://sh.rustup.rs -sSf | sh -s -- -y
      - source "$HOME/.cargo/env"

    - failhard: true

install_pkgs:
  pkg.installed:
    - pkgs:
      - tailscale
      - curl
      - htop
      - build-essential
      - pkg-config
      - esl-erlang
      - elixir
      - libssl-dev
      - gnupg

install_logflare_agent:
  cmd.run:
    - name:
      - git clone https://github.com/Logflare/logflare_agent.git /srv/logflare_agent
      - cd /srv/logflare_agent
      - mix deps.get
      - mix release
      - _build/dev/rel/logflare_agent/bin/logflare_agent start
