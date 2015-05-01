/*
 * QML Material - An application framework implementing Material Design.
 * Copyright (C) 2015 Steve Coffey <scoffey@barracuda.com>
 *               2015 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.0
import Material 0.1

PopupBase {
    id: bottomSheet

    /*!
       The maximum height of the bottom sheet. This is useful when used with a flickable,
       so the bottom sheet will scroll when the content is higher than the maximum height.
     */
    property int maxHeight: parent.height * 0.6
    
    default property alias content: containerView.data

    overlayLayer: "dialogOverlayLayer"
    overlayColor: Qt.rgba(0, 0, 0, 0.2)
    height: Math.min(maxHeight, implicitHeight)
    implicitHeight: containerView.childrenRect.height
    width: parent.width

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    anchors {
        bottom: parent.bottom
        bottomMargin: bottomSheet.showing ? 0 : -height

        Behavior on bottomMargin {
            NumberAnimation {
                duration: 200
                easing {
                     type: Easing.OutCubic
                }
            }
        }
    }

    View {
        id:containerView
        
        anchors.fill: parent

        elevation: 2
        backgroundColor: "#fff"
    }
}