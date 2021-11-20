/*
 * MECOTRON TUTORIAL
 *
 * This is a template to get you started in the course of the tutorial on the
 * control theory platforms, a.k.a. the MECOtrons.s
 * The tasks of the tutorial session will guide you through this template and
 * ask you to make use of the platform's capabilities in a step-by-step fashion.
 *
 * Every function in this template comes with an opening comment that describes
 * its purpose and functionality. Please also pay attention to the remarks that
 * are made in comment blocks.
 *
 */

#include "robot.h"

bool Robot::init() {
  MECOtron::init(); // Initialize the MECOtron

  // Initializing the robot's specific variables


  return true;
}

void Robot::control() {

  // Compute update of motor voltages if controller is enabled (triggered by
  // pushing 'Button 0' in QRoboticsCenter)
  if(controlEnabled()) {
    // Fill your control law here to conditionally update the motor voltage...
    LED1(ON);
    LED2(OFF);
     
    if (k==((T*100)-1)){
      k=0;
      state = !state;
      voltageState = !voltageState;
    }
    if (k==0){
      if (state){
        setVoltageMotorA(voltageA);
        setVoltageMotorB(voltageA);
      }
      else{
        setVoltageMotorA(0.0);
        setVoltageMotorB(0.0);
      }
    }
    k=k+1;
  }
  else {
    // If the controller is disabled, you might want to do something else...
    LED1(OFF);
    LED2(ON);
    setVoltageMotorA(0.0); // Apply 0.0 volts to motor A if the control is disabled
    setVoltageMotorB(0.0); // Apply 0.0 volts to motor B if the control is disabled
  }

  voltageA = readValue(0);
  N_pulses = readValue(1);
  T = readValue(2);
  
  float ra = getPositionMotorA(); // get the position of motor A [rad]
  float va = getSpeedMotorA();    // Get the wheel speed of motor A [rad/s]
  float ia = getCurrentMotorA();
  float volta = getVoltageMotorA();
  
  float rb = getPositionMotorB();
  float vb = getSpeedMotorB();
  float ib = getCurrentMotorB();
  float voltb = getVoltageMotorB();
  
  writeValue(0,ra);       // Send the value of variable k to QRoboticsCenter's channel 0
  writeValue(1,va);
  writeValue(2,voltageState);
  writeValue(3,rb);
  writeValue(4,vb);
  writeValue(5,ia);
  writeValue(6,ib);
  writeValue(7,volta);
  writeValue(8,voltb);
}

bool Robot::controlEnabled() {
  return _button_states[0];       // The control is enabled if the state of button 0 is true
}

void Robot::button0callback() {
  if(toggleButton(0)) {           // Switches the state of button 0 and checks if the new state is true
    init(); 
    message("Robot enabled.");    // Display a message in the status bar of QRoboticsCenter
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
