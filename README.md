# Devicons for Lite XL's project tree view

<img loading="lazy" width="1024px" src="./images/picture1.png" alt="image_name png" />

<img loading="lazy" width="1024px" src="./images/picture2.png" alt="image_name png" />

## How to install

> [!WARNING]
> `devicons` is currently undergoing maintenance.
> Anyone who wants to use `devicons` now should uninstall it with `lpm` (if it was previously installed) and just copy/paste the `devicons.lua` and `devicons.ttf` files.

### Manual (recommended)
```sh
# Go to your lite-xl directory
cd ~/.config/lite-xl/

# Create font subdirectory
mkdir fonts/font_devicons/
# Download devicons font
curl -o fonts/font_devicons/devicons.ttf https://raw.githubusercontent.com/PerilousBooklet/lite-xl-devicons/refs/heads/main/fontello-842ac128/font/devicons.ttf
# Download plugin
curl -o plugins/devicons.lua https://raw.githubusercontent.com/PerilousBooklet/lite-xl-devicons/refs/heads/main/devicons.lua
```

### Using lpm
Open a terminal window and run the following commands:
```sh
lpm repo add "https://github.com/PerilousBooklet/lite-xl-devicons"
lpm install devicons
```

## How to create a custom icon font

Follow the [official guide](https://lite-xl.com/developer-guide/samples/toolbarview/#create-a-custom-icon-font) ...

## Credits
- https://github.com/yamatsum/nonicons
- https://github.com/lite-xl/lite-xl-plugins/blob/master/plugins/nonicons.lua
