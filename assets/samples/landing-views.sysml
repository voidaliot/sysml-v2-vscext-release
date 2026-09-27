// Source of the landing page's Interconnection and Action Flow exports.
// Open IV on LandingViews::drone to see power and command connections.
// Open AFV on LandingViews::Mission to see the three sequential actions.
// Website exports use LR layout and hide port labels in the view settings.
// Ports have matching directions. These examples validate without diagnostics.
package LandingViews {
    item def Power;
    item def Command;
    port def PowerPort { out item supply : Power; }
    port def CommandPort { out item command : Command; }

    part drone {
        part battery { port output : PowerPort; }
        part controller {
            port power : ~PowerPort;
            port command : CommandPort;
        }
        part propulsion { port input : ~CommandPort; }
        connect battery.output to controller.power;
        connect controller.command to propulsion.input;
    }

    action def Mission {
        first start;
        then action plan;
        then action takeOff;
        then action deliver;
        then done;
    }
}
