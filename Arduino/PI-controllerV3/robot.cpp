/*
 * MECOTRON TUTORIAL - SOLUTION
 *
 * This is a possible solution for the PID controller that
 * is suggested in the tutorial session (part 2.7).
 *
 */

#include "robot.h"

bool Robot::init() {
  MECOtron::init(); // Initialize the MECOtron

  return true;
}

void Robot::control() {

  // Read the motor positions
  float yA = getSpeedMotorA();  //  read the encoder of motor A (in radians)
  float yB = getSpeedMotorB();  //  read the encoder of motor B (in radians)

  if(controlEnabled()) {
    /* If the control is enabled, then... */

    LED1(ON);   // turn on LED 1
    LED2(OFF);  // turn off LED 2

    if (driving == true){
    r = readValue(0);          //  use float channel 0 from QRC as the reference position (in radians)
    }
    
    // float Kp = readValue(9);
    // float Ki = readValue(10)
    float eA = r-yA;                 //  calculate the position error of motor A (in radians)
    float eB = r-yB;                 //  calculate the position error of motor B (in radians)

    // the actual control algorithm
    float uA = controlA + C_A*eA + D_A*errorA;        // the difference equation
    float uB = controlB + C_B*eB + D_B*errorB;        // the difference equation
    

    // store the new errors and new control signals in a member variable
  
    errorA = eA; errorB = eB; controlA = uA; controlB = uB;    // append the new values

    // apply the control signal
    setVoltageMotorA(uA);
    setVoltageMotorB(uB);

    // send errors and control signals to QRC
    writeValue(2, r);     // reference
    writeValue(3, eA);    // should go to zero
    writeValue(4, eB);    // should go to zero
    writeValue(5, uA);    // should (preferably) remain between -12V and 12V
    writeValue(6, uB);    // should (preferably) remain between -12V and 12V
    
  } else {
    /* If the control is disabled, then ... */

    LED1(OFF); // turn off LED 2
    LED2(ON);  // turn on LED 2
    setVoltageMotorA(0.0);  // don't move motor A
    setVoltageMotorB(0.0);  // don't move motor B
  }

  writeValue(0, yA);
  writeValue(1, yB);

}

void Robot::resetController(){
  // Set all errors and control signals in the memory back to 0
  errorA = 0.0;
  errorB = 0.0;
  controlA = 0.0;
  controlB = 0.0;
  
}

bool Robot::controlEnabled() {
  return _button_states[0];       // The control is enabled if the state of button 0 is true
}

void Robot::button0callback() {
  if(toggleButton(0)) {                          // Switches the state of button 0 and checks if the new state is true
    resetController();
    // driving = true;
//    Kp = readValue(9);
//    Ki = readValue(10);
//    Kd = readValue(11); 
//    float C = Kp+(Ki*TSAMPLE/2);
//    float D = (Ki*TSAMPLE/2) - Kp;
    message("Controller reset and enabled.");    // Display a message in the status bar of QRoboticsCenter
  }
  else {
    message("Robot disabled.");
  }
}

void Robot::button1callback() {
  toggleButton(1);
  init();                         // Reset the MECOtron and reinitialize the Robot object
  message("Reset.");
}

void Robot::button2callback(){
  if (toggleButton(2)){
    driving = false;
    r = 0.0;
    message("reference velocity set to 0");
  }
  else {
    driving = true;
    message("driving enabled");
  }
}
