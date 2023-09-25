package mprisctl

import (
	"time"
)

type state int

const (
	stateIdle state = iota
	stateRunning
	statePaused
)

type resumableTicker struct {
	checkPoint time.Time
	done       chan bool
	remaining  time.Duration
	state      state
	ticker     *time.Ticker
	callback   func()
	duration   time.Duration
}

func newTicker(duration time.Duration, callback func()) *resumableTicker {
	ticker := &resumableTicker{
		duration:  duration,
		remaining: 0,
		callback:  callback,
		state:     stateIdle,
	}
	return ticker
}

func waitFor(duration time.Duration) {
	timer := time.NewTimer(duration * time.Microsecond)
	<-timer.C
	return
}

func (t *resumableTicker) start() {
	if t.state != stateIdle {
		return
	}

	t.state = stateRunning
	t.done = make(chan bool, 1)
	t.checkPoint = time.Now()
	t.ticker = time.NewTicker(t.duration)
	go func() {
		for {
			select {
			case <-t.done:
				return
			case <-t.ticker.C:
				t.checkPoint = time.Now()
				t.callback()
			}
		}
	}()
}

func (t *resumableTicker) startAfter(delay time.Duration) {
	waitFor(delay)
	t.start()
}
func (t *resumableTicker) resumeAfter(delay time.Duration) {
	waitFor(delay)
	t.resume()
}

func (t *resumableTicker) stop() {
	if t.state == stateIdle {
		return
	}
	t.ticker.Stop()
	t.done <- true
	t.state = stateIdle
}

func (t *resumableTicker) pause() {
	if t.state != stateRunning {
		return
	}
	elapsed := time.Since(t.checkPoint)
	t.remaining = t.remaining - elapsed
	t.stop()
	t.state = statePaused
}

func (t *resumableTicker) resume() {
	if t.state != statePaused {
		return
	}
	t.stop()
	timer := time.NewTimer(t.remaining * time.Microsecond)
	<-timer.C
	t.start()
}

func (t *resumableTicker) resumeOrStart() {
	switch t.state {
	case statePaused:
		t.resume()
	case stateIdle:
		t.start()
	}
}

func (t *resumableTicker) resumeOrStartAfter(delay time.Duration) {
	if delay != 0 {
		waitFor(delay)
	}
	t.resumeOrStart()
}
