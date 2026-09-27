// Release capture model. No optional settings are required.
// Show Diagram on drone. Use IV with orthogonal lines and Fit.
// Browser: open propulsion with its Diagram pill, then use Up to return.
// Properties: select battery, expand Inherited, and edit capacity from 80 to 95.
// Expect a local capacity override. Battery's default and spareBattery stay 80.
// Inspect powerOutput to see its directed members and Conjugated control.
// The unconnected spare battery is deliberate and should have no diagnostic.
package DeliveryDrone {
    private import ScalarValues::*;

    port def PowerPort {
        out attribute voltage : Real;
        out attribute current : Real;
    }
    port def CommandPort {
        out attribute throttle : Real;
    }

    part def Battery {
        doc /* Supplies the flight computer and propulsion system. */
        attribute capacity : Real = 80;
        attribute nominalVoltage : Real = 22.2;
        attribute mass : Real = 1.2;
        port powerOutput : PowerPort;
    }
    part def FlightController {
        attribute firmware : String = "2.1";
        attribute updateRate : Real = 100;
        port powerInput : ~PowerPort;
        port motorCommand : CommandPort;
    }
    part def Motor {
        attribute maxSpeed : Real = 9200;
        attribute mass : Real = 0.3;
        port command : ~CommandPort;
    }

    part drone {
        doc /* Delivery drone. Explore its parts and edit their properties. */
        attribute payloadLimit : Real = 2.5;
        attribute cruiseSpeed : Real = 12;
        part battery : Battery {
            attribute :>> capacity = 95;
        }
        part flightController : FlightController;
        part propulsion {
            doc /* Four motors share the flight controller command. */
            port command : ~CommandPort;
            part frontLeft : Motor;
            part frontRight : Motor;
            part rearLeft : Motor;
            part rearRight : Motor;
            connect command to frontLeft.command;
            connect command to frontRight.command;
            connect command to rearLeft.command;
            connect command to rearRight.command;
        }
        connect battery.powerOutput to flightController.powerInput;
        connect flightController.motorCommand to propulsion.command;
    }
    part spareBattery : Battery;
}
