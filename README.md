# MCS-51-Architecture-Computer-Control-Program-Design
Computer Control

## I. Keyboard Input and LED Display Output
Develop and debug a 7-segment LED display control program:

Display each group's class number and student ID stably on the LED display.
Display format: "Class number (2 digits) + last 2 digits of one student's ID + last 2 digits of another student's ID," a total of 6 decimal digits.
Write and debug a keyboard input program:

Display the last entered key number permanently on the rightmost display block (LED0).
Shift the previous display content one position to the left in a cyclic manner.
Develop and debug a real-time clock program:

Allow keyboard input for current time: hours, minutes, and seconds.
Implement a 1-second timer using either interrupt-based timing or software delay.
Display the time correctly with standard carry-over.

## II. Stepper Motor Control
Establish hardware connections based on a self-designed plan.

Write and debug a program for controlling a 4-phase stepper motor:

Control the motor to operate in a four-phase single 4-step mode.
Rotate in specified steps, direction, and speed: accelerate 100 steps, maintain speed for 100 steps, decelerate 100 steps; reverse, accelerate 100 steps, maintain speed for 100 steps, decelerate 100 steps; repeat cyclically.

## III. DC Motor Control
Establish hardware connections based on a self-designed plan.

Write and debug a program for DC motor speed control:

Input the desired speed value (unit: revolutions per second) from the keyboard, displayed on the left 2 digits of the display.
Use a timer interrupt to calculate the actual speed based on the pulses counted within a unit time, displaying it on the LED display.
Compare the relationship between the actual speed and the desired value; increase or decrease the output to match the actual speed with the desired value.
