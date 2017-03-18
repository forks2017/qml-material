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
import QtQuick.Controls 1.3 as Controls
import QtQuick.Window 2.2
import Material 0.3
import Material.Extras 0.1

/*!
   \qmltype ApplicationWindow
   \inqmlmodule Material

   \brief A window that provides features commonly used for Material Design apps.

   This is normally what you should use as your root component. It provides a \l Toolbar and
   \l PageStack to provide access to standard features used by Material Design applications.

   Here is a short working example of an application:

   \qml
   import QtQuick 2.4
   import Material 0.3

   ApplicationWindow {
       title: "Application Name"

       initialPage: page

       Page {
           id: page
           title: "Page Title"

           Label {
               anchors.centerIn: parent
               text: "Hello World!"
           }
       }
   }
   \endqml
*/
Controls.ApplicationWindow {
    id: app

    /*!
       Set to \c true to include window decorations in your app's toolbar and hide
       the regular window decorations header.
     */
    property bool clientSideDecorations: false

    /*!
       \qmlproperty Page initialPage

       The initial page shown when the application starts.
     */
    property alias initialPage: __pageStack.initialItem

    /*!
       \qmlproperty PageStack pageStack

       The \l PageStack used for controlling pages and transitions between pages.
     */
    property alias pageStack: __pageStack

    /*!
       \qmlproperty AppTheme theme

       A grouped property that allows the application to customize the the primary color, the
       primary dark color, and the accent color. See \l Theme for more details.
     */
    property alias theme: __theme

    AppTheme {
        id: __theme
    }

    PlatformExtensions {
        id: platformExtensions
        decorationColor: __toolbar.decorationColor
        window: app
    }

    property int margin: 1
    PageStack {
        id: __pageStack
        anchors {
            left: parent.left
            right: parent.right
            top: __toolbar.bottom
            bottom: parent.bottom

            topMargin: 0
            leftMargin: isMaximized() || !isFrameLess() ? 0 : margin
            rightMargin: isMaximized() || !isFrameLess() ? 0 : margin
            bottomMargin: isMaximized() || !isFrameLess() ? 0 : margin
        }

        onPushed: __toolbar.push(page)
        onPopped: __toolbar.pop(page)
        onReplaced: __toolbar.replace(page)
    }

    Toolbar {
        id: __toolbar
        clientSideDecorations: app.clientSideDecorations

        anchors {
            topMargin: isMaximized() || !isFrameLess() ? 0 : margin
            leftMargin: isMaximized() || !isFrameLess() ? 0 : margin
            rightMargin: isMaximized() || !isFrameLess() ? 0 : margin
            bottomMargin: 0
        }

//        radius: 5
    }

    OverlayLayer {
        id: dialogOverlayLayer
        objectName: "dialogOverlayLayer"
    }

    OverlayLayer {
        id: tooltipOverlayLayer
        objectName: "tooltipOverlayLayer"
    }

    OverlayLayer {
        id: overlayLayer
    }

    width: dp(800)
    height: dp(600)

    Dialog {
        id: errorDialog

        property var promise

        positiveButtonText: "Retry"

        onAccepted: {
            promise.resolve()
            promise = null
        }

        onRejected: {
            promise.reject()
            promise = null
        }
    }

    function isFrameLess(){
        return true//app.flags & Qt.FramelessWindowHint
    }
    function isMaximized(){
        return app.visibility == Window.Maximized || app.visibility == Window.FullScreen
    }

    /*!
       Show an error in a dialog, with the specified secondary button text (defaulting to "Close")
       and an optional retry button.

       Returns a promise which will be resolved if the user taps retry and rejected if the user
       cancels the dialog.
     */
    function showError(title, text, secondaryButtonText, retry) {
        if (errorDialog.promise) {
            errorDialog.promise.reject()
            errorDialog.promise = null
        }

        errorDialog.negativeButtonText = secondaryButtonText ? secondaryButtonText : "Close"
        errorDialog.positiveButton.visible = retry || false

        errorDialog.promise = new Promises.Promise()
        errorDialog.title = title
        errorDialog.text = text
        errorDialog.open()

        return errorDialog.promise
    }

    // Units

    function dp(dp) {
        return dp * Units.dp
    }

    function gu(gu) {
        return units.gu(gu)
    }

    UnitsHelper {
        id: units
    }

    /*!
      Show window status when double clicked!
     */
    function switchMaxMimi(){
        if (app.visibility == Window.Maximized){
            app.showNormal()
        } else {
            app.showMaximized();
        }
    }

    MouseArea {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: pageStack.top
        }

        propagateComposedEvents: true

        property variant previousPosition
        onPressed: {
            previousPosition = Qt.point(mouseX, mouseY)
        }
        onPositionChanged: {
            if (pressedButtons == Qt.LeftButton && !isMaximized()) {
                var dx = mouseX - previousPosition.x
                var dy = mouseY - previousPosition.y
                app.setX(app.x+dx)
                app.setY(app.y+dy)
            }
        }

        onDoubleClicked: {
            if (mouseY < 50)
            {
                app.switchMaxMimi();
            }
        }
    }

    MouseArea{//���մ����ϲ�������¼������ڳ��������������ı䴰�ڵĴ�С
        id: mouse_top
        enabled: isFrameLess() && !isMaximized()//noBorder&&!fixedSize&&!fixedTopBorder&&app.windowStatus==MyQuickWindow.StopCenter
        cursorShape :enabled?Qt.SizeVerCursor:Qt.ArrowCursor//�����ʽ
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: app.width-6
        height: 3
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onPositionChanged: {
            var num_temp = pressedY-mouseY
            setTopBorder(num_temp)
        }
    }
    MouseArea{//���մ����²�������¼������ڳ��������������ı䴰�ڵĴ�С
        id: mouse_bottom
        enabled: isFrameLess() && !isMaximized()//noBorder&&!fixedSize&&!fixedBottomBorder&&app.windowStatus==MyQuickWindow.StopCenter
        cursorShape :enabled?Qt.SizeVerCursor:Qt.ArrowCursor
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: app.width-6
        height: 3
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedY = mouseY
        }
        onPositionChanged: {
            var num_temp = mouseY-pressedY
            setBottomBorder(num_temp)
        }
    }
    MouseArea{//���մ����󲿵�����¼������ڳ��������������ı䴰�ڵĴ�С
        id: mouse_left
        enabled: isFrameLess() && !isMaximized()//noBorder&&!fixedSize&&!fixedLeftBorder&&app.windowStatus==MyQuickWindow.StopCenter
        cursorShape :enabled?Qt.SizeHorCursor:Qt.ArrowCursor
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        height: app.height-6
        width: 3
        z:1
        property real pressedX: 0
        property real pressedY: 0

        onPressed: {
            pressedX = mouseX
        }
        onPositionChanged: {
            var num_temp = pressedX-mouseX
            setLeftBorder(num_temp)
        }
    }
    MouseArea{//���մ����Ҳ�������¼������ڳ��������������ı䴰�ڵĴ�С
        id: mouse_right
        enabled: isFrameLess() && !isMaximized()//noBorder&&!fixedSize&&!fixedRightBorder&&app.windowStatus==MyQuickWindow.StopCenter
        cursorShape :enabled?Qt.SizeHorCursor:Qt.ArrowCursor
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        height: app.height-6
        width: 3
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedX = mouseX
        }
        onPositionChanged: {
            var num_temp = mouseX-pressedX
            setRightBorder(num_temp)
        }
    }
    MouseArea{//���մ������ϲ�������¼������ڳ��������������ı䴰�ڵĴ�С
        enabled: isFrameLess() && !isMaximized()//mouse_left.enabled&&mouse_top.enabled
        cursorShape :enabled?Qt.SizeFDiagCursor:Qt.ArrowCursor
        anchors.left: parent.left
        anchors.top: parent.top
        height: 5
        width: 5
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onPositionChanged: {
            var num_temp1 = pressedX-mouseX
            setLeftBorder(num_temp1)
            var num_temp2 = pressedY-mouseY
            setTopBorder(num_temp2)
        }
    }
    MouseArea{//���մ������ϲ�������¼������ڳ��������������ı䴰�ڵĴ�С
        enabled: isFrameLess() && !isMaximized()//mouse_right.enabled&&mouse_top.enabled
        cursorShape :enabled?Qt.SizeBDiagCursor:Qt.ArrowCursor
        anchors.right: parent.right
        anchors.top: parent.top
        height: 5
        width: 5
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onPositionChanged: {
            var num_temp1 = mouseX-pressedX
            setRightBorder(num_temp1)
            var num_temp2 = pressedY-mouseY
            setTopBorder(num_temp2)
        }
    }
    MouseArea{//���մ������²�������¼������ڳ��������������ı䴰�ڵĴ�С
        enabled:isFrameLess()//mouse_left.enabled&&mouse_bottom.enabled
        cursorShape :enabled?Qt.SizeBDiagCursor:Qt.ArrowCursor
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: 5
        width: 5
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onPositionChanged: {
            var num_temp1 = pressedX-mouseX
            setLeftBorder(num_temp1)
            var num_temp2 = mouseY-pressedY
            setBottomBorder(num_temp2)
        }
    }
    MouseArea{//���մ������²�������¼������ڳ��������������ı䴰�ڵĴ�С
        enabled: isFrameLess() && !isMaximized()//mouse_right.enabled&&mouse_bottom.enabled
        cursorShape :enabled?Qt.SizeFDiagCursor:Qt.ArrowCursor
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 5
        width: 5
        z:1
        property real pressedX: 0
        property real pressedY: 0
        onPressed: {
            pressedX = mouseX
            pressedY = mouseY
        }
        onPositionChanged: {
            var num_temp1 = mouseX-pressedX
            setRightBorder(num_temp1)
            var num_temp2 = mouseY-pressedY
            setBottomBorder(num_temp2)
        }
    }

    signal manulPullLeftBorder//����û��ڴ�����������ı��˴��ڴ�С
    signal manulPullRightBorder//ͬ��
    signal manulPullTopBorder//ͬ��
    signal manulPullBottomBorder//ͬ��

    property bool fixedTopBorder: false//�̶��ϱ߿��ϱ߲�������
    property bool fixedBottomBorder: false//ͬ��
    property bool fixedLeftBorder: false//ͬ��
    property bool fixedRightBorder: false//ͬ��
    property var setTopBorder: mySetTopBorder//����������ϱ߿����õĺ���
    property var setBottomBorder: mySetBottomBorder//ͬ��
    property var setLeftBorder: mySetLeftBorder//ͬ��
    property var setRightBorder: mySetRightBorder//ͬ��
    function mySetLeftBorder(arg){//������߸ı䴰�ڵ�widthʱ
        if(!fixedLeftBorder){
            var temp = app.width
            app.width+=arg;
            temp = app.width-temp//��������еĲ�ֵ
            if(temp!=0){
                app.x-=temp//�ı䴰������
                manulPullLeftBorder()//������������߽���ź�
            }
        }
    }
    function mySetRightBorder(arg){//�����ұ߸ı䴰�ڵ�widthʱ
        if(!fixedRightBorder){
            var temp = app.width
            app.width+=arg;
            temp = app.width-temp//��������еĲ�ֵ
            if(temp!=0){
                manulPullRightBorder()//�����������ұ߽���ź�
            }
        }
    }
    function mySetTopBorder(arg){//�����ϱ߸ı䴰�ڵ�widthʱ
        if(!fixedTopBorder){
            var temp = app.height
            app.height+=arg;
            temp = app.height-temp//��������еĲ�ֵ
            if(temp!=0){
                app.y-=temp//�ı䴰������
                manulPullTopBorder()//�����������ϱ߽���ź�
            }
        }
    }
    function mySetBottomBorder(arg){//�����±߸ı䴰�ڵ�widthʱ
        if(!fixedBottomBorder){
            var temp = app.height
            app.height+=arg;
            temp = app.height-temp//��������еĲ�ֵ
            if(temp!=0){
                manulPullBottomBorder()//�����������±߽���ź�
            }
        }
    }
    function showFront() {//��ʾ����ǰ��
        if(app.visible) {
            if( app.visibility == Window.Minimized){
                app.show()
            }
            app.requestActivate()//�ô�����ʾ����ǰ��
        }
    }

    Component.onCompleted: {
        if (clientSideDecorations)
            flags |= Qt.FramelessWindowHint
    }
}
