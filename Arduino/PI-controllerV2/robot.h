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

class Robot : public MECOtron {
  private:

    // Member variables
      // boolean to reset reference value to 0
      bool driving = true;
      float r = 0.0;
      
      // Remember the 2 previous errors
      float errorA = 0.0;       // stores e[k-1] of motor A during iteration
      float errorB = 0.0;       // stores e[k-1] of motor B during iteration
  
      // Remember the 2 previous control signals
      float controlA = 0.0;     // stores u[k-1] of motor A during iteration
      float controlB = 0.0;     // stores u[k-1] of motor B during iteration

      // Controller parameters   
      // Values are initialized here, this is needed!
//      float Kp = 0.0;
//      float Ki = 0.0; 
//      float Kd = 0.0; 
//      float C = 0.0;
//      float D = 0.0;
//      // float C = Kp+Ki*TSAMPLE/2;
//      // float D = Ki*TSAMPLE/2 - Kp;

      float Kp = 0.6977;
      float Ki = 6.1432 ; 
      float C = Kp+(Ki*TSAMPLE/2);
      float D = (Ki*TSAMPLE/2) - Kp;

  public:
    // Constructor
    Robot() { }

    void control();

    // General functions
    bool init();  // Set up the robot

    bool controlEnabled();

    void button0callback();
    void button1callback();
    void button2callback();
    
    // Controller related functions
    void resetController(); 

};

#endif // ROBOT_H
