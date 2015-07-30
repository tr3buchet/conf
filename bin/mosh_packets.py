#!/usr/bin/python

import iptc

MOSH_PACKETS = '/tmp/mosh_packets'
MOSH_STATE = '/tmp/mosh_state'


def packet_count():
    table = iptc.Table(iptc.Table.FILTER)
    chain = iptc.Chain(table, 'INPUT')
    for rule in chain.rules:
        if rule.protocol == 'udp' and [m.dport for m in rule.matches
                                       if m.dport == '60000:61000']:
            packets, __ = rule.get_counters()
            if packets:
                return packets


def last_packet_count():
    try:
        with open(MOSH_PACKETS, 'r') as f:
            return int(f.read())
    except IOError:
        return 0


def write_file(filename, data):
    with open(filename, 'w') as f:
        f.write(str(data))


if __name__ == '__main__':
    packets = packet_count()

    if packets is None:
        state = 'fail'
    else:
        if packets > last_packet_count():
            state = 'connected'
        else:
            state = 'disconnected'
        write_file(MOSH_PACKETS, packets)
    write_file(MOSH_STATE, state)
