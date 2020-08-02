#!/bin/env python3

import os
import argparse

os.getenv('XDG_CONFIG_DIR')

parser = argparse.ArgumentParser(description='Install stow directories of components.')
#parser.add_argument('integers', metavar='N', type=int, nargs='+',
                    #help='an integer for the accumulator')
parser.add_argument('--all', action='store_true',
                    help='Stow all packages')

args = parser.parse_args()

class Stow():
    def __init__(self, package: str,
                 hidden_prefix: str = '.',
                 unhidden_prefix: str = 'dot-'):
        self.package = package
        self.hidden_prefix = hidden_prefix
        self.unhidden_prefix = unhidden_prefix

    @staticmethod
    def swap_prefix(string, old_prefix, new_prefix):
        if string.startswith(old_prefix):
            base = string[len(old_prefix):]
            return f'{new_prefix}{base}'
        return None

    @staticmethod
    def toggle_hidden(f):
        new_name = swap_prefix(f.name, hidden_prefix, unhidden_prefix)
        new_name = new_name or swap_prefix(f.name, unhidden_prefix, hidden_prefix)
        if new_name is None:
            return
        try:
            os.rename(f.path, new_name)
            return new_name
        except IsADirectoryError:
            # f is a file, but toggled f is a directory
            return
        except NotADirectoryError:
            # f is a directory, but toggled f is a file
            return
        except OSError:
            # Both f and toggled f are directories, but toggled f is non-empty
            return
        except FileExistsError:
            # Windows only uses this exception for all the above
            return

# for now, the --dotfiles option for stow files doesn't work for directories
def undot(dir_):
    for f in os.scandir(dir_):
        if f.name.startswith('.'):
            print(f.path)

        if f.is_dir:
            undot(f.path)
        elif f.is_symlink:
            print(f.name, f.path, f.stat)
        elif f.is_file:
            o
        else:
            print(f"Unexpected filetype: {f}")
            assert False

        print(f.stat)
        
        #if os.readlink(path, *, dir_fd=None)¶

def redot(package):
    for root, dirs, files in os.walk(f'components/{package}'):
        for d in dirs:
            print(d)
        #if os.readlink(path, *, dir_fd=None)¶

def main():
    undot('components/ssh-ident/stow')

if __name__ == '__main__':
    main()

#PACKAGES="*"
#PACKAGES="ssh ssh-ident"
#
#cd components
#for i in $PACKAGES; do
#    cd "$i"
#    if [ -d stow ]; then
#	#stow -n -v --no-folding --dir="stow" --target="$HOME/" .
#	stow -v --no-folding --dir="stow" --target="$HOME/" .
#    fi
#    if [ -d root_stow ]; then
#	#sudo stow -n -v --no-folding --dir="root_stow" --target="/" .
#	sudo stow -v --no-folding --dir="root_stow" --target="/" .
#    fi
#    cd ..
#done

# for now, --dotfiles doesn't work very well...
# cd "$i"
# for j in *; do
#         mv $j .${j:4}
# done
# cd ../../..
