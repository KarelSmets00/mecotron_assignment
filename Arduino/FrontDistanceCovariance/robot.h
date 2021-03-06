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
    // Class variables
    
  public:
    // Constructor
    Robot() { }

    void control();

    // General functions
    bool init();  // Set up the robot

    bool controlEnabled();

    void button0callback();
    void button1callback();

    float voltageA = 0.0;
    int N_pulses = 0;
    int N = 0;
    float T = 0;
    int k = 0;
    bool state = true; 

    bool voltageState = true;

};

#endif // ROBOT_H
