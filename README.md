# Keyboards

Firmware sources and a shared [devenv](https://devenv.sh) build environment
for my keyboards:

| Keyboard | Firmware | Sources |
|---|---|---|
| BastardKB Charybdis 4x6 | QMK | `bastardkb-qmk/` (firmware), `qmk_userspace/` (my keymap) |
| Beekeeb Toucan2 | ZMK | `zmk-keyboard-toucan2/` |

## Setup

Clone with submodules — the keyboard repos are submodules, and they have
submodules of their own (QMK's libraries, BastardKB's QMK modules):

```sh
git clone --recurse-submodules <this repo>
```

For an existing clone, or after pulling a submodule update:

```sh
git submodule update --init --recursive
```

Then allow direnv to load the devenv shell (needs Nix, devenv and direnv):

```sh
direnv allow
```

The shell provides `qmk`, `west`, the ARM/AVR compilers and flashing tools,
and sets `QMK_HOME`/`QMK_USERSPACE`, so no `qmk setup` or `qmk config` is
needed.

## Building

| Command | Output |
|---|---|
| `charybdis` | `qmk_userspace/bastardkb_charybdis_4x6_splinktegrated_rev1_slavoutich.uf2` |

Flash a `.uf2` by putting the keyboard into its bootloader and copying the
file onto the USB drive that appears.

## License

The files in this repository are licensed under [0BSD](LICENSE). The
submodules keep their own licenses: `bastardkb-qmk` and `qmk_userspace` are
GPL-2.0, `zmk-keyboard-toucan2` is MIT.
