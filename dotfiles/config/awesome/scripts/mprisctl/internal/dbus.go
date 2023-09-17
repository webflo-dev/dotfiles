package mprisctl

import (
	"github.com/godbus/dbus/v5"
)

type DBus struct {
	Connection *dbus.Conn
}

func NewDBus() *DBus {
	dbusConnection, err := dbus.SessionBus()
	if err != nil {
		panic(err)
	}

	return &DBus{
		Connection: dbusConnection,
	}
}

func (_dbus *DBus) Close() {
	_dbus.Connection.Close()
}

func Store[T any](source []interface{}) T {
	var value T
	var iface string
	var unknown []string
	dbus.Store(source, &iface, &value, &unknown)
	return value
}

func (_dbus *DBus) WatchSignal() chan *dbus.Signal {
	channel := make(chan *dbus.Signal, 10)
	_dbus.Connection.Signal(channel)
	return channel
}

func (_dbus *DBus) CallMethodWithBusObject(methodName string, args ...interface{}) *dbus.Call {
	return _dbus.CallMethod(_dbus.Connection.BusObject(), methodName, args...)
}

func (_dbus *DBus) CallMethod(dbusObj dbus.BusObject, methodName string, args ...interface{}) *dbus.Call {
	return dbusObj.Call(methodName, 0, args...)
}

func (_dbus *DBus) GetProperty(dest string, path dbus.ObjectPath, property string) (dbus.Variant, error) {
	return _dbus.Connection.Object(dest, path).GetProperty(property)
}

func (_dbus *DBus) SetProperty(dest string, path dbus.ObjectPath, property string, value interface{}) error {
	return _dbus.Connection.Object(dest, path).SetProperty(property, dbus.MakeVariant(value))
}
