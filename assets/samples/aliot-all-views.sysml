// Aliot all-view tour. This is a readable model, not a test fixture.
// No optional language settings are required. Use curved or orthogonal lines.
// GV group/tree: AliotShowcase::Architecture. IV/GEV: ::Architecture::drone.
// AFV: ::Mission. STV: ::FlightMode. SV: ::DeliverySequence.
// CV: ::Operations. GRV Requirements: AliotShowcase (includes satisfy claims).
// The media generator supplies per-view presentation settings with port labels on.
// Every physical part is connected. Open powerFeed and commandBus to see flows.
// Expand controller.commands and propulsion.drives to see their nested ports.
// IV closes geometry attribute lists; GEV still shows their complete solids.
// GV Tree usage labels sit on the approach to each target part definition.
// State regions are concurrent; there is no transition from one region to another.
// AFV lanes are performance claims, not duplicate actions or ownership changes.
// Sequence lifelines refer to existing parts, not additional physical components.
// Geometry omits nonspatial controls. Requirements use known values and pass.
package AliotShowcase {
    private import ScalarValues::*;
    private import SI::*;
    private import SpatialItems::SpatialItem;
    private import ShapeItems::*;
    private import MeasurementReferences::Translation;
    private import MeasurementReferences::TranslationRotationSequence;

    package Architecture {
        item def Power;
        item def Command;
        port def PowerPort { out item supply : Power; }
        port def CommandPort { out item command : Command; }
        port def CommandBus {
            port drive : CommandPort;
            port payload : CommandPort;
        }
        port def RotorBus {
            port left : CommandPort;
            port right : CommandPort;
        }
        port def MountPort;
        connection def PowerCable {
            end source : PowerPort;
            end target : ~PowerPort;
            flow powerTransfer from source.supply to target.supply;
        }
        interface def CommandLink {
            end source : CommandPort;
            end target : ~CommandPort;
            flow commandTransfer from source.command to target.command;
        }
        part def Battery { port powerOut : PowerPort; }
        part def Controller {
            port powerIn : ~PowerPort;
            port reservePowerIn : ~PowerPort;
            port commands : CommandBus;
        }
        part def Propulsion {
            port commandIn : ~CommandPort;
            port drives : RotorBus;
            port mount : MountPort;
        }
        part def Airframe :> SpatialItem { port mount : MountPort; }
        part def PayloadBay :> SpatialItem { port controlIn : ~CommandPort; }
        part def Rotor :> SpatialItem { port commandIn : ~CommandPort; }
        part def Drone :> SpatialItem {
            attribute payload : Real = 2.0;
            attribute endurance : Real = 35.0;
        }
        part drone : Drone {
            attribute :>> coordinateFrame { :>> mRefs = (m, m, m); }
            part battery : Battery { perform AliotShowcase::Mission.checkPower; }
            part reserveBattery : Battery;
            part controller : Controller {
                perform AliotShowcase::Mission.plan;
                perform AliotShowcase::Mission.checkRoute;
                perform AliotShowcase::Mission.retryLink;
                perform AliotShowcase::Mission.deliver;
            }
            part propulsion : Propulsion;
            // Open these two relationships: named ends and carried flows appear
            // inside their blocks. The other links keep their compact pills.
            connection powerFeed : PowerCable connect source references battery.powerOut
                to target references controller.powerIn;
            connection backupFeed : PowerCable connect source references reserveBattery.powerOut
                to target references controller.reservePowerIn;
            interface commandBus : CommandLink connect source references controller.commands.drive
                to target references propulsion.commandIn;
            interface payloadCommands : CommandLink connect source references controller.commands.payload
                to target references payloadBay.controlIn;
            interface leftDrive : CommandLink connect source references propulsion.drives.left
                to target references leftRotor.commandIn;
            interface rightDrive : CommandLink connect source references propulsion.drives.right
                to target references rightRotor.commandIn;
            connection frameMount connect airframe.mount to propulsion.mount;

            // These are the actual physical parts, placed in the drone frame.
            part airframe : Airframe {
                item :>> shape : Box {
                    :>> length = 0.60 [m]; :>> width = 0.24 [m]; :>> height = 0.12 [m];
                }
                attribute :>> coordinateFrame {
                    :>> transformation : TranslationRotationSequence {
                        :>> elements = new Translation((0.0, 0.0, 0.12)[source]);
                    }
                }
            }
            part payloadBay : PayloadBay {
                item :>> shape : Box {
                    :>> length = 0.24 [m]; :>> width = 0.18 [m]; :>> height = 0.12 [m];
                }
                attribute :>> coordinateFrame {
                    :>> transformation : TranslationRotationSequence {
                        :>> elements = new Translation((0.0, 0.0, -0.06)[source]);
                    }
                }
            }
            part leftRotor : Rotor {
                item :>> shape : Cylinder { :>> radius = 0.14 [m]; :>> height = 0.03 [m]; }
                attribute :>> coordinateFrame {
                    :>> transformation : TranslationRotationSequence {
                        :>> elements = new Translation((0.0, 0.35, 0.15)[source]);
                    }
                }
            }
            part rightRotor : Rotor {
                item :>> shape : Cylinder { :>> radius = 0.14 [m]; :>> height = 0.03 [m]; }
                attribute :>> coordinateFrame {
                    :>> transformation : TranslationRotationSequence {
                        :>> elements = new Translation((0.0, -0.35, 0.15)[source]);
                    }
                }
            }
            satisfy AliotShowcase::Requirements::payloadLimit;
            satisfy AliotShowcase::Requirements::flightTime;
        }
    }

    // Fork/join makes power and route checks concurrent. The named retry loop
    // belongs to the controller's lane and displays its authored until condition.
    action Mission {
        attribute linkReady : Boolean = true;
        action plan;
        fork checks;
        action checkPower;
        action checkRoute;
        join ready;
        action retryLink loop { action poll; } until linkReady;
        action deliver;
        first start then plan;
        succession plan then checks;
        succession checks then checkPower;
        succession checks then checkRoute;
        succession checkPower then ready;
        succession checkRoute then ready;
        succession ready then retryLink;
        succession retryLink then deliver;
        succession deliver then done;
    }

    // active contains two independent regions with their own initial states.
    state FlightMode {
        attribute routeClear : Boolean = true;
        attribute lowBattery : Boolean = false;
        entry; then standby;
        state standby;
        parallel state active {
            state navigation {
                entry; then cruising;
                state cruising { do action followRoute; }
                state avoiding;
                transition obstacle first cruising if not routeClear then avoiding;
                transition clear first avoiding if routeClear then cruising;
            }
            state monitoring {
                entry; then healthy;
                state healthy { do action sampleBattery; }
                state warning;
                transition lowPower first healthy if lowBattery then warning;
            }
        }
        state landed;
        transition launch first standby then active;
        transition touchdown first active then landed;
        transition finish first landed then done;
    }

    part def Operator;
    part operator : Operator;
    item def MissionRequest;
    item def Status;
    occurrence DeliverySequence {
        attribute monitoring : Boolean = true;
        ref part pilot = operator;
        ref part controller = Architecture::drone.controller;
        ref part propulsion = Architecture::drone.propulsion;
        message requestMission of MissionRequest from pilot to controller;
        message startMotors of Architecture::Command from controller to propulsion;
        // The loop frame covers both messages and retains the condition label.
        while monitoring {
            message requestStatus of Status from controller to propulsion;
            message reportStatus of Status from propulsion to controller;
        }
        message deliveryComplete of Status from controller to pilot;
    }

    package Operations {
        use case def DeliverParcel {
            subject vehicle : Architecture::Drone;
            actor pilot : Operator;
            include CheckReadiness;
        }
        use case def CheckReadiness {
            subject vehicle : Architecture::Drone;
            actor pilot : Operator;
        }
        use case deliver : DeliverParcel {
            subject vehicle = Architecture::drone;
            actor pilot = AliotShowcase::operator;
        }
        use case ready : CheckReadiness {
            subject vehicle = Architecture::drone;
            actor pilot = AliotShowcase::operator;
        }
    }

    package Requirements {
        requirement <'PAY-01'> payloadLimit {
            doc /* Payload shall not exceed 3 kg. The value is expressed in kg. */
            subject vehicle : Architecture::Drone = Architecture::drone;
            require constraint { vehicle.payload <= 3.0 }
        }
        requirement <'OPS-01'> flightTime {
            doc /* Endurance shall be at least 30 minutes. The value is expressed in minutes. */
            subject vehicle : Architecture::Drone = Architecture::drone;
            require constraint { vehicle.endurance >= 30.0 }
        }
        verification checkPayload {
            subject vehicle = Architecture::drone;
            objective { verify payloadLimit; }
        }
        verification checkEndurance {
            subject vehicle = Architecture::drone;
            objective { verify flightTime; }
        }
    }
}
