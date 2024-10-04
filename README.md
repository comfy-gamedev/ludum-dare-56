Apples' Godot Jam Template
==========================

This project template is designed to get a jam game project up and running as quickly as possible.
It includes several commonly-implemented scripts and tweaked project settings.

Quick Overview
--------------

> [!NOTE]
> Classes are fully documented using GDScript documentation comments.

> [!NOTE]
> Many pre-made wiki pages are included which describe common conventions.

### Scenes

| Name | Description
|:--|:--
| `main_menu` | A simple but functional main menu which demonstrates `SceneGirl`.
| `main_gameplay` | A basic scene demonstrating `CameraShake`, `BouncingCharacterBody2D`, `MotionInterpolator2D`.

### Node Types

| Name | Description
|:--|:--
| `BouncingCharacterBody*D` | An extended `CharacterBody*D` which behaves as a perfectly elastic body which maintains a constant speed.
| `CameraShake` | Used as a child node for a `Camera*D`, provides two methods of camera shake.
| `GenericSignaller` | A small script which simply provides a generic `event` signal, useful for animations in imported scenes.
| `MotionInterpolator*D` | Provides physics interpolation and damped motion to its child node.

### Autoloads

| Name | Description
|:--|:--
| `Globals` | An empty global variable bag with a togglable debug overlay that displays all variables.
| `MusicMan` | A music and sfx player which automates `AudioStreamPlayer` nodes.
| `SceneGirl` | A scene changer which also handles transitions and loading screens.
| `TestCameraManager` | Adds a simple controllable camera when running scenes in isolation.

### Utility Scripts

| Name | Description
|:--|:--
| `Future` | An async wrapper which allows awaiting multiple signals at once.

### Addons

| Name | Description
|:--|:--
| Cider Wiki | Adds the Wiki main screen tab.

### Project Settings Changes

```ini
[application]

boot_splash/minimum_display_time.release=2000

[audio]

buses/default_bus_layout="res://audio_bus_layout.tres"

[display]

window/stretch/mode="canvas_items"

[gui]

theme/custom="res://gui_theme.tres"

[importer_defaults]

texture={
"detect_3d/compress_to": 0
}

[rendering]

textures/canvas_textures/default_texture_filter=0
renderer/rendering_method="gl_compatibility"
```
