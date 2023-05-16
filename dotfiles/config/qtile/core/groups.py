from libqtile.config import Key, ScratchPad, DropDown
from libqtile.config import Group, Match
from libqtile.lazy import lazy

from utils.settings import terminal

from .keys import keys, MOD, SHIFT

groups = [
    Group(
        # exclusive=True,
        name="code",
        label="",
        layout="monadtall",
        matches=[Match(wm_instance_class=["code", "Code"])],
    ),
    Group(
        # exclusive=True,
        name="web",
        label="",
        layout="columns",
        matches=[Match(wm_instance_class=["microsoft-edge","firefox", "Firefox", "Navigator"])],
    ),
    Group(
        # exclusive=True,
        name="terminal",
        label="",
        layout="monadtall",
        # matches=[Match(wm_instance_class=["alacritty", "Alacritty"])],
    ),
    Group(
        # exclusive=True,
        name="messaging",
        label="",
        layout="monadtall",
        matches=[Match(wm_instance_class=["discord", "Discord"])],
    ),
    Group(
        name="misc",
        label="",
        layout="monadtall",
    )
]

keys.extend([
    Key([MOD], "ampersand", lazy.group["code"].toscreen(), desc="Switch to group code"),
    Key([MOD, SHIFT], "ampersand", lazy.window.togroup("code", switch_group=True), desc="Switch to & move focused window to group code"),

    Key([MOD], "eacute", lazy.group["web"].toscreen(), desc="Switch to group web"),
    Key([MOD, SHIFT], "eacute", lazy.window.togroup("web", switch_group=True), desc="Switch to & move focused window to group web"),

    Key([MOD], "quotedbl", lazy.group["terminal"].toscreen(), desc="Switch to group terminal"),
    Key([MOD, SHIFT], "quotedbl", lazy.window.togroup("terminal", switch_group=True), desc="Switch to & move focused window to group terminal"),

    Key([MOD], "apostrophe", lazy.group["messaging"].toscreen(), desc="Switch to group messaging"),
    Key([MOD, SHIFT], "apostrophe", lazy.window.togroup("messaging", switch_group=True), desc="Switch to & move focused window to group messaging"),

    Key([MOD], "parenleft", lazy.group["misc"].toscreen(), desc="Switch to group misc"),
    Key([MOD, SHIFT], "parenleft", lazy.window.togroup("misc", switch_group=True), desc="Switch to & move focused window to group misc"),
])
# group_hotkeys=["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft"]
# for i, group in enumerate(groups):
#     if not isinstance(i, ScratchPad):
#         group = group.name
#         keys.extend([
#             Key([MOD], group_hotkeys[i], lazy.group[group].toscreen(), desc="Switch to group {}".format(group)),
#             Key([MOD, SHIFT], group_hotkeys[i], lazy.window.togroup(group, switch_group=True), desc="Switch to & move focused window to group {}".format(group)),
#         ])



groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown("alacritty", terminal, opacity=0.9, width=0.8, height=0.5, x=0.1, y=0.25),
            DropDown("pulsemixer", "alacritty --command=\"pulsemixer\"", opacity=0.9, width=0.8, height=0.5, x=0.1, y=0.25)
        ],
    )
)
