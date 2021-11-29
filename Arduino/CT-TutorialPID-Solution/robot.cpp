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
    float uA = n0d0*eA + n1d0*errorA[0] + n2d0*errorA[1] - d2d0*controlA[1]; // equation (2), the difference equation
    float uB = n0d0*eB + n1d0*errorB[0] + n2d0*errorB[1] - d2d0*controlB[1]; // equation (2), the difference equation

    // store the new errors and new control signals in a member variable
    for(int k=0; k<1; k++) {
      errorA[k+1] = errorA[k];        // shift the memorized errors of motor A with 1 sample
      errorB[k+1] = errorB[k];        // shift the memorized errors of motor B with 1 sample
      controlA[k+1] = controlA[k];    // shift the memorized control signals of motor A with 1 sample
      controlB[k+1] = controlB[k];    // shift the memorized control signals of motor B with 1 sample
    }
    errorA[0] = eA; errorB[0] = eB; controlA[0] = uA; controlB[0] = uB;    // append the new values

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
  for(int k=0; k<2; k++) {
    errorA[k] = 0.0;
    errorB[k] = 0.0;
    controlA[k] = 0.0;
    controlB[k] = 0.0;
  }
}

bool Robot::controlEnabled() {
  return _button_states[0];       // The control is enabled if the state of button 0 is true
}

void Robot::button0callback() {
  if(toggleButton(0)) {                          // Switches the state of button 0 and checks if the new state is true
    resetController();
    // driving = true;
    Kp = readValue(9);
    Ki = readValue(10);
    Kd = readValue(11); 
    n0d0 = Kp + Ki*TSAMPLE/2 + 2*Kd/TSAMPLE; // 2.05
    n1d0 = Ki*TSAMPLE - 4*Kd/TSAMPLE; // 0.1
    n2d0 = -Kp + Ki*TSAMPLE/2 + 2*Kd/TSAMPLE; // -1.95
    d2d0 = -1.0; 
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
