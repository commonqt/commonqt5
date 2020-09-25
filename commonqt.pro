unix:TEMPLATE     = lib
win32:TEMPLATE    = vclib

HEADERS     += commonqt.h
SOURCES     += commonqt.cpp
CONFIG      += qt thread debug dll
QT = core gui widgets

unix:LIBS += -lsmokeqtcore -lsmokebase
win32:LIBS += smokebase.lib smokeqtcore.lib smokeqtgui.lib smokeqtwidget.lib
