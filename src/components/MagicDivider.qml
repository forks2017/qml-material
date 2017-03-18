/*
 * QML Material - An application framework implementing Material Design.
 *
 * Copyright (C) 2014-2016 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

import QtQuick 2.4

/*!
   \qmltype MagicDivider
   \inqmlmodule Material

   \brief A 1dp high divider for use in lists and other columns of content.
 */
Item {
    id: outline
    anchors {
        left: parent.left
        right: parent.right
    }
    height: 1

    property int styleDivider: 1
    property color color: Qt.rgba(0,0,0,0.1)
    property int dash_len: dp(5)

    onColorChanged: {
        if (styleDivider > 1)
            canvas.requestPaint()
    }

    Rectangle {
        anchors {
            fill: parent
        }

        visible: styleDivider === 1

        color: outline.color
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        visible: styleDivider > 1

        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()

        renderStrategy: Canvas.Threaded
        antialiasing: true
        onPaint: draw()

        opacity:  visible ? 1.0 : 0

        function draw() {
            var ctx = getContext("2d")
            // 设置画笔
            ctx.lineWidth = 2;
            ctx.strokeStyle = outline.color
            if (styleDivider === 2)
                drawDashLine(ctx, 0, parent.height/2, parent.width, parent.height/2, dash_len)
            else if (styleDivider === 3)
                drawRectangle(ctx, 0, 0, parent.width, parent.height, 13)
        }

        Component.onCompleted: {
            requestPaint();
        }
    }

    function drawRectangle(ctx, x, y, width, height, radius, fill, stroke) {
        if (typeof stroke == "undefined") {
            stroke = true;
        }
        if (typeof radius === "undefined") {
            radius = 5;
        }
        radius = 0;
        drawDashLine(ctx, x + radius, y, x + width - radius, y, dash_len, false);
        drawDashLine(ctx, x + width, y + radius, x + width, y + height - radius, dash_len, false);
        drawDashLine(ctx, x + width - radius, y+ height, x + radius, y + height, dash_len, false);
        drawDashLine(ctx, x, y + height - radius, x, y + radius, dash_len);
    }

    function drawDashLine(ctx, x1, y1, x2, y2, dashLen, stroke){
        if (typeof stroke == "undefined") {
            stroke = true;
        }
        if (typeof dashLen == "undefined") {
            // default interval distance -> 5px
            dashLen = 5;
        }
        var dx = x2 - x1 //得到横向的宽度;
        var dy = y2 - y1 //得到纵向的高度;
        var numDashes = Math.floor(Math.sqrt(dx * dx + dy * dy) / dashLen);
        //利用正切获取斜边的长度除以虚线长度，得到要分为多少段;
        for(var i=0; i <numDashes; i++){
            if(i % 2 === 0){
                ctx.moveTo(x1 + (dx/numDashes) * i, y1 + (dy/numDashes) * i);
                //有了横向宽度和多少段，得出每一段是多长，起点 + 每段长度 * i = 要绘制的起点；
            }else{
                ctx.lineTo(x1 + (dx/numDashes) * i, y1 + (dy/numDashes) * i);
            }
        }
        if (stroke) {
            ctx.stroke();
        }
    }

}
