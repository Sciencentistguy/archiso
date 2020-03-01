#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/

# Install dotfiles
rm -f /root/.zshrc
ln -s /.dotfiles/zshrc /root/.zshrc
ln -s /.dotfiles/aliases.zsh /root/.zsh/
ln -s /.dotfiles/functions.zsh /root/.zsh/
ln -s /.dotfiles/zsh-plugins /root/.zsh/plugins

mkdir -p /root/.config/nvim
ln -s /.dotfiles/init.vim /root/.config/nvim/init.vim

nvim +PlugInstall

chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

systemctl enable pacman-init.service choose-mirror.service
systemctl enable NetworkManager.service
systemctl set-default multi-user.target
