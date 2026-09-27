// Port glyphs (user direction 2026-09-24). Open the Interconnection View on
// PortGlyphs::cockpit and compare each port with the note beside it.
//
// Nothing is drawn inside a port. Every port name is a PILL standing in
// front of its port, centred on it. A port with CONTENTS has a `+` on its
// pill. Its contents are its nested ports, the directed items of its type,
// or both. An OPEN port shows no name: its `−` sits inside the bar at its top
// (at its left end on a top or bottom edge). No port has a tooltip. Hover a
// small item box or an open port, which show no name: a pill `name : Type`
// shows in front of it. Hover a port that has a pill: nothing new shows.
//
// Each `+` opens one level only, and each `−` closes one level only. A
// click on the pill text selects the port. A drag on the port moves it.
//
// A port name stays in front of its port even where a line runs through it:
// the pill stands above the line, like the pill of a line.
//
// This file needs no settings. Nothing here is opt-in.
package PortGlyphs {
    item def Signal;
    item def Tick;
    item def Key;
    item def Grant;
    item def Command;
    item def Status;

    // No directed items and no nested ports: a port of this type has no
    // contents, so its pill has no `+`.
    port def PlainPort;
    port def PowerPort { in supply : Signal; }
    port def DataPort { out sample : Signal; }
    port def ClockPort { out tick : Tick; }
    port def SyncPort {
        out port tick : ClockPort;
        in port tock : ~ClockPort;
    }
    port def BusPort {
        in port power : PowerPort;
        out port data : DataPort;
        port sync : SyncPort;
    }
    // Two directed items and two nested ports on one port.
    port def CombinedPort {
        out item command : Command;
        in item status : Status;
        port debug : DataPort;
        port power : PowerPort;
    }

    port def DevicePort {
        out key : Key;
        in grant : Grant;
        in status : Signal;
    }
    port def VehiclePort :> ~DevicePort;

    part def Cloud { out port uplink : DataPort; }
    part def Gateway { part cloud : Cloud; }

    interface def Session {
        end port device : DevicePort;
        end port vehicle : VehiclePort;
        flow key : Key from device.key to vehicle.key;
        flow grant : Grant from vehicle.grant to device.grant;
        flow status : Signal from vehicle.status to device.status;
    }

    part cockpit {
        part hub {
            // `bus` owns nested ports. Closed, it is an ordinary port box
            // with a two-headed arrow (its nested ports go both ways), and
            // its name is a pill `bus` with a `+` at its end.
            // Press the `+`: `bus` becomes a thin bar, one port thick, with no
            // name and no arrow on it, and a `−` inside its top. `power`,
            // `data` and `sync` sit on its outer edge at the ordinary port
            // size. Each of the three is closed and has its own pill with a
            // `+`, because each has contents of its own.
            // Press `+` on `power`: one small box `supply` (arrow in) pops out
            // of the thin `power` bar. It has no name and no `+`; hover it: a
            // pill `supply : Signal` shows in front of it. Press `+` on `sync`: `tick` (out) and
            // `tock` (in, hollow) sit on the edge of the thin `sync` bar, each
            // with its own `+` for its `tick` item. The `−` at the top of
            // `sync` folds `sync` alone and leaves `bus` open.
            // Drag the pill of `power` anywhere: it stays there, and a
            // double-click puts it back in front of `power`. Hover or select
            // the open `bus`: a small grip shows at its bottom end. Drag it:
            // the bar grows about its centre and `power`, `data` and `sync`
            // spread out over it; a double-click on the grip returns it to its
            // own length. Then drag `sync` up or down along `bus`: it stands
            // where it is dropped, with its own ports on it; a double-click on
            // `sync` puts it back. None of this changes the source.
            port bus : BusPort;

            // A plain port: an ordinary box, an arrow pointing out, and its
            // name `plain` on a pill in front of it. `PlainPort` has no
            // contents, so the pill has no `+`.
            out port plain : PlainPort;

            // A conjugated port is HOLLOW: filled with the canvas colour, its
            // outline and arrow in the usual port colours. Its pill reads
            // `~back` with a `+`, because `DataPort` declares the item
            // `sample`. Open it: one small box `sample` pops out, its arrow
            // `in` here.
            in port back : ~DataPort;
        }

        // Items and nested ports on one port. `link` on `tx` and on `rx` is
        // closed, and the flow `cmd` runs from port to port with its pill
        // `Command`.
        // Press `+` on the `tx` pill: `link` becomes a thin bar. Two small
        // boxes pop out of its outer edge first, `command` (arrow out) and
        // `status` (arrow in), with no name and no `+`. Then `debug` and
        // `power` follow at the port size, each closed with its own `+`.
        // The flow now leaves from the `command` box and still ends on the
        // closed `rx.link`. Press `+` on the `rx` pill too: the flow runs
        // from item to item. The flow in the source never changes.
        // Select `tx.link`: Properties lists `debug` and `power` under Ports
        // and `out command : Command` and `in status : Status` under
        // Directed features.
        part tx { port link : CombinedPort; }
        part rx { port link : ~CombinedPort; }
        flow cmd : Command from tx.link.command to rx.link.command;

        part phone { port keyOut : DevicePort; }
        part lock { port keyIn : VehiclePort; }

        // `«interface» session : Session` is one line with one pill. Hover the
        // pill: a `+` shows, because `Session` carries flows. Press it: the
        // usage opens into a blue box.
        // Its two ends are PORTS in the connection colour. Compare an end with
        // `tx.link`: the same rounded box and outline, only blue. The arrows of
        // an end point the way its items travel through the interface: `key`
        // on `device` points into the box, `key` on `vehicle` out of it. The
        // ends start OPEN, so each shows no name and a `−` at its left end: an
        // interface is opened to read its items. Closed, an end reads its
        // name on a blue pill (`device`, `vehicle`). Three small blue boxes pop out of each end INTO the box, one
        // per item its port type declares: `key`, `grant` and `status`. Hover
        // one: a pill with its item and type shows outside the end. The title
        // steps down below them.
        // Three flows run inside the box, each between its own two items,
        // drawn like a flow between parts: an arrow at the receiving item and
        // the label on the line, nearer the sending item. `key : Key` runs
        // towards `vehicle`, `grant : Grant` and `status : Signal` towards
        // `device`. The `vehicle` end reads the same
        // items the other way round, because `VehiclePort` is the conjugate
        // of `DevicePort`.
        // Press the `−` of `device`: its items fold, its pill `device` shows,
        // and the three lines dock on the whole `device` end. Each now carries
        // its flow as an arrow ON the line, since one of its ends shows no item.
        interface session : Session connect (device ::> phone.keyOut, vehicle ::> lock.keyIn);

        // The connector reaches `uplink`, a port of `cloud`, two parts deep.
        // Close `gateway` with the `−` on its title: `cloud` is hidden, and the
        // connector keeps a place to dock, a PROXY on the edge of `gateway`.
        // It is an ordinary-size port box with a DASHED outline and an arrow
        // pointing out, named `cloud.uplink`, the path of the port it stands
        // for. Press `+` on `gateway`: the proxy goes and the connector docks
        // on `uplink` again.
        part gateway : Gateway;
        part roadside { in port link : ~DataPort; }
        connect roadside.link to gateway.cloud.uplink;
        connect session.vehicle.key to lock.keyIn;
    }

    // Adding a port on the diagram inside a port that the part inherits
    // writes one redefinition per step, each with the kind of what it
    // redefines. Select `backup`, open `bus`, then `sync`, and add a port to
    // `sync`: the source gains
    //     port :>> bus { port :>> sync { port added; } }
    // and the new port shows on `sync`. `part :>> bus` would be wrong: a part
    // cannot redefine a port. Written by hand, it is error SSM062 on the
    // keyword `part`, and its quick fix "Redefine it as a port" writes `port`.
    part backup : BackupHub;
    part def BackupHub { port bus : BusPort; }
}
