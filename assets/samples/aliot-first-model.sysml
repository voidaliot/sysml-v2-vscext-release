// Aliot first model and theme showcase.
// In Preferences: Color Theme, choose Aliot Dark.
// Existing settings keep the stable identifier:
// { "workbench.colorTheme": "SysML v2 Default" }
// Choose SysML v2 Gray to compare the light presentation.
// Open General View on AliotFirstModel. Rover lists its three owned parts.
// Names, types and attributes should remain readable in either theme.
// This model needs no special lint settings and should show no diagnostics.
package AliotFirstModel {
    private import ScalarValues::*;

    part def Battery {
        attribute capacity : Real = 80.0;
    }
    part def Controller;
    part def Motor;

    part def Rover {
        part battery : Battery;
        part controller : Controller;
        part motor : Motor;
    }
    // Show Diagram here, or select rover in the Browser pane.
    // Rename controller through Properties to see the source change.
    part rover : Rover;
}
