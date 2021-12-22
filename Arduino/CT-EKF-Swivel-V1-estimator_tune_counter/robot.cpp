/*
 * EXTENDED KALMAN FILTER TEMPLATE
 *
 * This is a template to get you started with the implementation of the Kalman filter
 * on your own cart.
 *
 */

#include "robot.h"

bool Robot::init() {
  MECOtron::init(); // Initialize the MECOtron

  desiredVelocityCart(0) = 0.0;
  desiredVelocityCart(1) = 0.0;
  return true;
}

void Robot::control() {

  float volt_A = 0.0;
  float volt_B = 0.0;
  float desiredVelocityMotorA = 0.0;
  float desiredVelocityMotorB = 0.0;
  Matrix<2> desiredVelocityCart; // control signal
  desiredVelocityCart.Fill(0); //Initialize matrix with zeros
  Matrix<2> uff;
  Matrix<2> measurements;

  // Kalman filtering
  if(controlEnabled() || KalmanFilterEnabled()) {   // only do this if Kalman filter is enabled (triggered by pushing 'Button 1' in QRoboticsCenter)

    // Correction step
    // perform the correction step if measurement from the sensor are meaningful
    if(trajectory.hasMeasurements()){
      measurements(0) = getFrontDistance();
      measurements(1) = getSideDistance();
      CorrectionUpdate(measurements, _xhat, _Phat, _nu, _S, _L);     // do the correction step -> update _xhat, _Phat, _nu, _S
       writeValue(9, measurements(0));
       writeValue(10, measurements(1));
    }

    if (count < upper_count){
      _xhat(2) = 0.0;
    }

    // // Useful outputs to QRC for assignment questions
     writeValue(0, _xhat(0));
     writeValue(1, _xhat(1));
     writeValue(2, _xhat(2));
     writeValue(3, _Phat(0,0));
     writeValue(4, _Phat(1,0));
     writeValue(5, _Phat(1,1));
     writeValue(6, _Phat(2,0));
     writeValue(7, _Phat(2,1));
     writeValue(8, _Phat(2,2));
  }

  if(controlEnabled()) {   // only do this if controller is enabled (triggered by pushing 'Button 0' in QRoboticsCenter)

    // UNCOMMENT AND COMPLETE LINES BELOW TO IMPLEMENT THE FEEDFORWARD INPUTS (ASSIGNMENT 5.2, no state feedback here)
    // COMMENT OR REMOVE LINES BELOW ONCE YOU IMPLEMENT THE POSITION STATE FEEDBACK CONTROLLER
    // Compute feedforward uff = [v w]
    // The feedforward are here returned by the built-in trajectory: trajectory.v() and trajectory.omega()
    uff(0) = trajectory.v();          //desired forward velocity of the cart (in m/s)
    uff(1) = trajectory.omega();      //desired rotational velocity of the cart (in rad/s)
    // The trajectory must be started by pushing 'Button 2' in QRoboticsCenter, otherwise will return zeros
    // after any experiment the trajectory must be reset pushing 'Button 3' in QRoboticsCenter
    //
    // Desired velocity of the cart just feedforward in this case
    desiredVelocityCart = uff;  // desired forward and rotational velocity of the cart from the feedforward and state feedback controller
    //
    // // apply the static transformation between velocity of the cart and velocity of the motors
     desiredVelocityMotorA = (desiredVelocityCart(0)-desiredVelocityCart(1)*WHEELBASE/2) / R_WHEEL;;  // calculate the angular velocity of the motor A using desiredVelocityCart(0) (cart forward velocity) and desiredVelocityCart(0) (cart rotational velocity)
     desiredVelocityMotorB = (desiredVelocityCart(0)+desiredVelocityCart(1)*WHEELBASE/2) / R_WHEEL;  // calculate the angular velocity of the motor B using desiredVelocityCart(0) (cart forward velocity) and desiredVelocityCart(0) (cart rotational velocity)



//     // UNCOMMENT AND COMPLETE LINES BELOW TO IMPLEMENT POSITION CONTROLLER (ASSIGNMENT 5.3)
//     // The reference is here given by built-in trajectory: trajectory.X(), trajectory.Y(), trajectory.Theta()
//     xref(0)=trajectory.X();        // desired X cart position [m]
//     xref(1)=trajectory.Y();        // desired Y cart position [m]
//     xref(2)=trajectory.Theta();    // desired cart angle [rad]
//    
//     // Controller tuning
//     float arrayKfb[2][3]{{7, 0, 0},  // state feedback gain K, to design
//                          {0, 5, 30}};
//     Matrix<2, 3> Kfb = arrayKfb;
//    
//     // Compute control action
//     // Firstly, compute error in world-frame ew = xref - x
//     Matrix<3> ew = xref - _xhat;
//    
//     /// Secondly, compute rotation matrix
//     float arrayRw2c[3][3]{{cos(_xhat(2,0)),    sin(_xhat(2,0)),    0},
//                           {-sin(_xhat(2,0)),   cos(_xhat(2,0)),    0},
//                           {0,                  0,                  1}};
//    
//     Matrix<3, 3> Rw2c = arrayRw2c;
//     /// Thirdly, rotate error to cart-frame ec = Rw2c*ew
//     Matrix<3> ec = Rw2c * ew;
//     /// Fourthly, compute feedback ufb = Kfb*ec
//     Matrix<2> ufb = Kfb * ec;
//     /// Fifthly, compute feedforward uff = [v w]
//     uff(0) = trajectory.v();
//     uff(1) = trajectory.omega();
//     // Sixtly, compute the control action u = uff + ufb
//     // desiredVelocityCart = uff + ufb;  // desired forward and rotational velocity of the cart from the feedforward and state feedback controller
//     
//     desiredVelocityCart = ufb;  // desired forward and rotational velocity of the cart from the feedforward and state feedback controller
//
//     desiredVelocityMotorA = (desiredVelocityCart(0)-desiredVelocityCart(1)*WHEELBASE/2) / R_WHEEL;;  // calculate the angular velocity of the motor A using desiredVelocityCart(0) (cart forward velocity) and desiredVelocityCart(0) (cart rotational velocity)
//     desiredVelocityMotorB = (desiredVelocityCart(0)+desiredVelocityCart(1)*WHEELBASE/2) / R_WHEEL;  // calculate the angular velocity of the motor B using desiredVelocityCart(0) (cart forward velocity) and desiredVelocityCart(0) (cart rotational velocity)

      
    // UNCOMMENT AND COMPLETE LINES BELOW TO IMPLEMENT VELOCITY CONTROLLER
     // Read the motor positions
    float yA = getSpeedMotorA();  //  read the encoder of motor A (in radians)
    float yB = getSpeedMotorB();  //  read the encoder of motor B (in radians)

    rA = desiredVelocityMotorA;          //  use float channel 0 from QRC as the reference position (in radians)
    rB = desiredVelocityMotorB;
  
    float eA = rA-yA;                 //  calculate the position error of motor A (in radians)
    float eB = rB-yB;                 //  calculate the position error of motor B (in radians)

    // the actual control algorithm
    float uA = controlA + C_A*(eA+errorA);        // the difference equation
    float uB = controlB + C_B*(eB+errorB);        // the difference equation

    // store the new errors and new control signals in a member variable
    errorA = eA; errorB = eB; controlA = uA; controlB = uB;    // append the new values

    // COMMENT OR REMOVE LINES BELOW ONCE YOU IMPLEMENT THE VELOCITY CONTROLLER
    volt_A = uA;
    volt_B = uB;

    // // COMMENT OR REMOVE LINES BELOW ONCE YOU IMPLEMENT THE VELOCITY CONTROLLER
//    volt_A = 0.0;
//    volt_B = 0.0;

    // Send wheel speed command
    setVoltageMotorA(volt_A);
    setVoltageMotorB(volt_B);
    
//    writeValue(0, _xhat(0,0));
//    writeValue(1, _xhat(1,0));
//    writeValue(2, _xhat(2,0));
//    writeValue(3, trajectory.X());
//    writeValue(4, trajectory.Y());
//    writeValue(5, trajectory.Theta());
////    writeValue(6, ew(0));
////    writeValue(7, ew(1));
////    writeValue(8, ew(2));
//    writeValue(6, _L(2,0));
//    writeValue(7, _L(2,1));
//    writeValue(8, _nu(1));
//    
//    writeValue(9,desiredVelocityCart(0));
//    writeValue(10,desiredVelocityCart(1));
//    writeValue(11, cos(1.57));
  }
  else                      // do nothing since control is disables
  {
   desiredVelocityCart(0) = 0.0;
   desiredVelocityCart(1) = 0.0;
   setVoltageMotorA(0.0);
   setVoltageMotorB(0.0);
  }

  // Kalman filtering
  if(controlEnabled() || KalmanFilterEnabled()) {   // only do this if Kalman filter is enabled (triggered by pushing 'Button 1' in QRoboticsCenter)
    // Prediction step
    PredictionUpdate(desiredVelocityCart, _xhat, _Phat);                        // do the prediction step -> update _xhat and _Phat
  }

  // Send useful outputs to QRC
  // to check functioning of trajectory and feedforward
//  writeValue(0, trajectory.v());
//  writeValue(1, trajectory.omega());
//  writeValue(2, trajectory.X());
//  writeValue(3, trajectory.Y());
//  writeValue(4, trajectory.Theta());
//  writeValue(5, trajectory.hasMeasurements());
//  writeValue(6, getSpeedMotorA());
//  writeValue(7, getSpeedMotorB());
//  writeValue(8, measurements(0));
//  writeValue(9, measurements(1));
//  writeValue(10, volt_A);
//  writeValue(11, volt_B);


  //triggers the trajectory to return the next values during the next cycle
  trajectory.update();

  //
  count += 1;
}

void Robot::resetController(){
  // Set all errors and control signals in the memory back to 0
  errorA = 0.0;
  errorB = 0.0;
  controlA = 0.0;
  controlB = 0.0;
}

void Robot::resetKalmanFilter() {
   // UNCOMMENT AND MODIFY LINES BELOW TO IMPLEMENT THE RESET OF THE KALMAN FILTER
   // Initialize state covariance matrix
    _Phat.Fill(0);      // Initialize the covariance matrix
    _Phat(0,0) = 0.001;     // Fill the initial covariance matrix, you can change this according to your experiments
    _Phat(1,1) = 0.001;
    _Phat(2,2) = 0.0001;    // 10 graden fout
  
   // Initialize state estimate
   _xhat(0) = -0.3;    // Change this according to your experiments
   _xhat(1) = -0.2;
   _xhat(2) = 0.0;
  
   // Reset innovation and its covariance matrix
   _S.Fill(0);
   _nu.Fill(0);
}

void Robot::resetCounter(){
  count = 0;
}

bool Robot::controlEnabled() {
  return _button_states[0];       // The control is enabled if the state of button 0 is true
}

bool Robot::KalmanFilterEnabled() {
  return _button_states[1];
}

void Robot::button0callback() {
  if(toggleButton(0)) {           // Switches the state of button 0 and checks if the new state is true
    resetCounter();
    resetController();
    resetKalmanFilter();            // Reset the Kalman filter
    trajectory.start();
    writeValue(0, _xhat(0));
    message("Controller reset and enabled.");    // Display a message in the status bar of QRoboticsCenter
  }
  else {
    trajectory.stop();
    message("Control disabled.");
  }
}

void Robot::button1callback() {
  if(toggleButton(1)){
      resetKalmanFilter();            // Reset the Kalman filter
      message("Kalman filter reset and enabled.");
  }
  else
  {
    message("Kalman filter disabled.");
  }
}

void Robot::button2callback() {
  if(toggleButton(2)) {
    trajectory.start();
    message("Trajectory started/resumed.");
  } else {
    trajectory.stop();
    message("Trajectory stopped.");
  }
}

void Robot::button3callback() {
    _button_states[2] = 0;
    trajectory.reset();
    message("Trajectory reset.");
}
