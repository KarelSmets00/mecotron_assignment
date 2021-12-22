#ifndef ROBOT_H
#define ROBOT_H

/*
 * ROBOT Class
 *
 * Class incorporating the robot. This class is used to define state machines,
 * control algorithms, sensor readings,...
 * It should be interfaced with the communicator to send data to the world.
 *
 */

#include "mecotron.h" // Include MECOTRON header
#include <BasicLinearAlgebra.h> // Include BasicLinearAlgebra to make matrix manipulations easier
#include "extended_kalman_filter.h" // Include template to make extended Kalman filter implementation easier

#define SWIVEL
#include <trajectory.h> // Include trajectory, for assignment 5

class Robot : public MECOtron {
  private:

    // Class variables
    Trajectory trajectory; // define the reference trajectory object

    // Kalman filter
    Matrix<3> _xhat;       // state estimate vector
    Matrix<3,3> _Phat;     // state estimate covariance
    Matrix<2> _nu;         // innovation vector
    Matrix<2,2> _S;        // innovation covariance
    Matrix<3,2> _L;        // kalman gain
    
    // Position controller
    Matrix<3> xref;        // reference state
    Matrix<2> desiredVelocityCart; // control signal

    // Volicity controller variables
      float rA = 0.0;
      float rB = 0.0;

      // Remember the 2 previous errors
      float errorA = 0.0;       // stores e[k-1] of motor A during iteration
      float errorB = 0.0;       // stores e[k-1] of motor B during iteration
  
      // Remember the 2 previous control signals
      float controlA = 0.0;     // stores u[k-1] of motor A during iteration
      float controlB = 0.0;     // stores u[k-1] of motor B during iteration
      
      // Controller parameters 
      float Ki_A = 2.6763; 
      float C_A = Ki_A*TSAMPLE/2;

      float Ki_B = 2.9855; 
      float C_B = Ki_B*TSAMPLE/2;
  
  public:
    // Constructor
    Robot() { }

    void control();

    // General functions
    bool init();  // Set up the robot

    bool controlEnabled();
    bool KalmanFilterEnabled();

    void resetController();
    void resetKalmanFilter();

    void button0callback();
    void button1callback();
    void button2callback();
    void button3callback();

};

#endif // ROBOT_H
