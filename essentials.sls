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
    - name: wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb --output /tmp/erlang.deb
    - failhard: true
  cmd.run:
    - name: sudo dpkg -i /tmp/erlang.deb

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
    - name: curl https://sh.rustup.rs -sSf | sh -s -- -y

install_pkgs:
  pkg.installed:
    - pkgs:
      - tailscale
      - curl
      - htop
      - build-essential
      - pkg-config
      - esl-erlang
      - libssl-dev
      - gnupg

# Installs Elixir from Source
install_elixir:
  cmd.run:
    - name: git clone https://github.com/elixir-lang/elixir.git ~/elixir
  cmd.run:
    - name: cd ~/elixir
  cmd.run:
    - name: make install
  # Check if the line already exists
  # cmd.run:
  #  - name: grep -qxF 'export PATH="$PATH:~/elixir/bin"' ~/.profile || echo 'export PATH="$PATH:~/elixir/bin"' >> ~/.profile
