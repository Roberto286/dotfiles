import QtQuick
import Quickshell
import qs.Common
import qs.DCommon.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property int pending: 0

    // Lines `fawos-update --check` prints per pending update:
    // "image: A -> B", "flatpak user: app -> commit", mise dry-run "would upgrade ...".
    function refresh() {
        Proc.runCommand("fawosUpdate.check", ["fawos-update", "--check"], (stdout, exitCode) => {
            root.pending = stdout.split("\n").filter(l => /^(image|flatpak[^:]*):|would (upgrade|update)/i.test(l)).length;
        }, 0);
    }

    Timer {
        interval: 3600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }

    pillClickAction: () => Quickshell.execDetached(["ghostty", "-e", "bash", "-c", "fawos-update; read -rp 'Press Enter to close'"])
    pillRightClickAction: () => root.refresh()

    horizontalBarPill: Component {
        Row {
            spacing: Theme.spacingXS

            DIcon {
                name: "system_update_alt"
                size: root.iconSize
                color: root.pending > 0 ? Theme.primary : Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }

            StyledText {
                visible: root.pending > 0
                text: root.pending
                font.pixelSize: root.textSize
                font.weight: Theme.fontWeightMedium
                color: Theme.surfaceText
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    verticalBarPill: Component {
        Column {
            spacing: 1

            DIcon {
                name: "system_update_alt"
                size: root.iconSize
                color: root.pending > 0 ? Theme.primary : Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }

            StyledText {
                visible: root.pending > 0
                text: root.pending
                font.pixelSize: root.textSize
                color: Theme.surfaceText
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }
}
