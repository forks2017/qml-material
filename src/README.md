+ Add two commands below to project setting in qt creator:

nmake install
qmlplugindump  -nonrelocatable Material 0.3 %{CurrentProject:QT_HOST_BINS}/../qml/Material > %{CurrentProject:QT_HOST_BINS}/../qml/Material/plugin.qmltypes