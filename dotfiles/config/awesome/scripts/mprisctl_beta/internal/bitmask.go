package mprisctl

type Byte uint8

func (b Byte) HasOneOf(bb Byte) bool {
	return (b & bb) != 0
}

func (b *Byte) Set(flag Byte) {
	*b |= flag
}

func (b *Byte) Clear(flag Byte) {
	*b &= ^flag
}

func (b *Byte) Toggle(flag Byte) {
	*b ^= flag
}
