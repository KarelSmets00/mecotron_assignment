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
      float errorA[2] = {0.0, 0.0};
      float errorB[2] = {0.0, 0.0};

      // Remember the 2 previous control signals
      float controlA[2] = {0.0, 0.0};
      float controlB[2] = {0.0, 0.0};

      // Controller parameters   
      // Values are initialized here, this is needed!
      float Kp = 0.0;
      float Ki = 0.0; 
      float Kd = 0.0; 
      float n0d0 = Kp + Ki*TSAMPLE/2 + 2*Kd/TSAMPLE; // 2.05
      float n1d0 = Ki*TSAMPLE - 4*Kd/TSAMPLE; // 0.1
      float n2d0 = -Kp + Ki*TSAMPLE/2 + 2*Kd/TSAMPLE; // -1.95
      float d2d0 = -1.0; 

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
