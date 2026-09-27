package DeliveryDrone {
    part def Battery;
    part def FlightController;
    part def Propulsion;
    part def Navigation;

    part def Drone {
        part battery : Battery;
        part flightComputer : FlightController;
        part propulsion : Propulsion;
        part navigation : Navigation;
    }
    part drone : Drone;
}
