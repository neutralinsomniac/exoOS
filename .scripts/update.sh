#! @bash@
set -e

if [[ ! $# -eq 2 && ! $# -eq 3 ]]
then
  echo "$0: <config> <user@host> [port]"
  exit
fi

CONFIG=$1
HOST=$2

if [[ $# -eq 3 ]]
then
  PORT=$3
else
  PORT=22
fi

CLOSURE=$(nix build --print-out-paths .#nixosConfigurations.${CONFIG}.config.system.build.toplevel)

NIX_SSHOPTS="-p ${PORT}" nix copy --to ssh://${HOST} ${CLOSURE}

ssh -p ${PORT} -t ${HOST} "sudo nix-env -p /nix/var/nix/profiles/system --set ${CLOSURE} && sudo ${CLOSURE}/bin/switch-to-configuration switch"
