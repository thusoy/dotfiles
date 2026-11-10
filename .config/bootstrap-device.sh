#/bin/sh

set -eu

# Don't show untracked files for the dotfiles repo
git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no

# Set scroll direction
defaults write -g com.apple.swipescrolldirection -boolean NO

# Set dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

# Set keyboard navigation in prompts
defaults write -g AppleKeyboardUIMode -int 2

# Create the initial directory to hold code
mkdir -p code

# Add keyboard shortcuts, @ is Cmd, ^ is Control, ~ is Option and $ is shift
defaults write -g NSUserKeyEquivalents -dict-add "Lock Screen" '$@x'

# Set repeat rate and initial delay
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10
