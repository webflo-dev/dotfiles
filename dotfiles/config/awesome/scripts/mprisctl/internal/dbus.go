package mprisctl

import (
	"github.com/godbus/dbus/v5"
)

type dbusWrapper struct {
	connection *dbus.Conn
}

func newDBus() *dbusWrapper {
	dbusConnection, err := dbus.SessionBus()
	if err != nil {
		panic(err)
	}

	return &dbusWrapper{
		connection: dbusConnection,
	}
}

func store[T any](source []interface{}) T {
	var value T
	var iface string
	var unknown []string
	dbus.Store(source, &iface, &value, &unknown)
	return value
}

func (_dbus *dbusWrapper) watchSignal() chan *dbus.Signal {
	channel := make(chan *dbus.Signal, 10)
	_dbus.connection.Signal(channel)
	return channel
}

func (_dbus *dbusWrapper) callMethodWithBusObject(methodName string, args ...interface{}) *dbus.Call {
	return _dbus.callMethod(_dbus.connection.BusObject(), methodName, args...)
}

func (_dbus *dbusWrapper) callMethod(dbusObj dbus.BusObject, methodName string, args ...interface{}) *dbus.Call {
	return dbusObj.Call(methodName, 0, args...)
}

func (_dbus *dbusWrapper) getProperty(dest string, path dbus.ObjectPath, property string) (dbus.Variant, error) {
	return _dbus.connection.Object(dest, path).GetProperty(property)
}

func (_dbus *dbusWrapper) setProperty(dest string, path dbus.ObjectPath, property string, value interface{}) error {
	return _dbus.connection.Object(dest, path).SetProperty(property, dbus.MakeVariant(value))
}
