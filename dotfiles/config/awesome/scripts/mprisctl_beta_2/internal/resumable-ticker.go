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

type ResumableTicker struct {
	checkPoint time.Time
	done       chan bool
	remaining  time.Duration
	state      state
	ticker     *time.Ticker
	callback   func()
	duration   time.Duration
}

func NewTicker(duration time.Duration, callback func()) *ResumableTicker {
	ticker := &ResumableTicker{
		duration:  duration,
		remaining: 0,
		callback:  callback,
		state:     stateIdle,
	}
	return ticker
}

func waitFor(duration time.Duration) {
	timer := time.NewTimer(duration)
	<-timer.C
	return
}

func (t *ResumableTicker) Start() {
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

func (t *ResumableTicker) StartAfter(delay time.Duration) {
	waitFor(delay)
	t.Start()
}
func (t *ResumableTicker) ResumeAfter(delay time.Duration) {
	waitFor(delay)
	t.Resume()
}

func (t *ResumableTicker) Stop() {
	if t.state == stateIdle {
		return
	}
	t.ticker.Stop()
	t.done <- true
	t.state = stateIdle
}

func (t *ResumableTicker) Pause() {
	if t.state != stateRunning {
		return
	}
	elapsed := time.Since(t.checkPoint)
	t.remaining = t.remaining - elapsed
	t.Stop()
	t.state = statePaused
}

func (t *ResumableTicker) Resume() {
	if t.state != statePaused {
		return
	}
	t.Stop()
	timer := time.NewTimer(t.remaining * time.Microsecond)
	<-timer.C
	t.Start()
}

func (t *ResumableTicker) ResumeOrStart() {
	switch t.state {
	case statePaused:
		t.Resume()
	case stateIdle:
		t.Start()
	}
}

func (t *ResumableTicker) ResumeOrStartAfter(delay time.Duration) {
	waitFor(delay)
	t.ResumeOrStart()
}
