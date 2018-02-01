#!/usr/bin/fish

# Change username here to your preferred username
set username max
# Set version of credits client to be used
set version "v1.1.1.0"

if cat /proc/cpuinfo | grep avx2
	set version -avx2
else
	set version
end

set file "credits-1.1.1-linux$version.tar.gz"
set url "https://github.com/CRDS/Credits/releases/download/$version/$file"

if not test -e $file
	wget $url
end
tar xf $file

mkdir -p $HOME/.local/bin
set dir dirname (find -name 'creditsd')
echo "Installing static binaries to \$HOME/.local/bin"
mv $dir/* $HOME/.local/bin
rmdir $dir

echo "ROOT: Copying systemd service to /etc/systemd/system/"
sudo cp creditsd.service /etc/systemd/system/creditsd.service
sudo cp creditsd-affinity.service /etc/systemd/system/creditsd-affinity.service
sudo systemctl enable --now creditsd creditsd-affinity
