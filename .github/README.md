# Dotfiles

Inspired by https://www.atlassian.com/git/tutorials/dotfiles.

There's an alias for git named `config` that you should use when working with the dotfiles.


## Setting up a new device

1. Create a HW-bound ssh key: `sc_auth create-ctk-identity -l ssh -k p-256-ne -t none`
2. Download the resident key from Secure Enclave: `(cd .ssh && ssh-keygen -w /usr/lib/ssh-keychain.dylib -K -N '')`
3. Add the pubkey to your GitHub profile.
4. Do a bare clone of the dotfiles repo: `git clone --bare git@github.com:thusoy/dotfiles $HOME/.dotfiles`
5. Checkout the branch for your platform: `git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME checkout mac`
6. Run the bootstrap script: `~/.config/bootstrap-device.sh`
7. Restart the computer to apply everything.
