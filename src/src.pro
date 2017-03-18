TEMPLATE = lib
TARGET = material

CONFIG += c++11
QT += qml quick


android {
    QT += androidextras svg xml
}

HEADERS += plugin.h \
           core/device.h \
           core/units.h

SOURCES += plugin.cpp \
           core/device.cpp \
           core/units.cpp

RESOURCES += $$PWD/../icons/icons_all.qrc

target.path = $$[QT_INSTALL_QML]/Material

material.files +=  \
                    components/* \
                    controls/* \
                    core/* \
                    popups/* \
                    window/*
material.path = $$[QT_INSTALL_QML]/Material

components.files += components/*
components.path = $$[QT_INSTALL_QML]/Material/components

controls.files += controls/*
controls.path = $$[QT_INSTALL_QML]/Material/controls

core.files += core/*
core.path = $$[QT_INSTALL_QML]/Material/core

popups.files += popups/*
popups.path = $$[QT_INSTALL_QML]/Material/popups

window.files += window/*
window.path = $$[QT_INSTALL_QML]/Material/window

extras.files += extras/*
extras.path = $$[QT_INSTALL_QML]/Material/Extras

listitems.files += listitems/*
listitems.path = $$[QT_INSTALL_QML]/Material/ListItems

styles.files += styles/*
styles.path = $$[QT_INSTALL_QML]/Material/Styles
#styles.path = $$[QT_INSTALL_QML]/QtQuick/Controls/Styles/Material

icons.files += ../icons/*
icons.path = $$[QT_INSTALL_QML]/icons

#qmldir.target = $$OUT_PWD/out/qmldir
#qmldir.commands = mkdir -p $$OUT_PWD/out;
#qmldir.commands += sed \"s/$$LITERAL_HASH plugin material/plugin material/\" $$PWD/qmldir > $$qmldir.target
#qmldir.depends = $$PWD/qmldir
qmldir.path = $$[QT_INSTALL_QML]/Material
qmldir.files = $$PWD/qmldir
qmldir.CONFIG += no_check_exist

INSTALLS += target qmldir components controls core popups window extras listitems styles# icons

OTHER_FILES += $$material.files $$extras.files $$listitems.files $$styles.files $$PWD/README.md
