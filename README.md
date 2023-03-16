# OTFS SDR Implementation with Channel Emulator
This is the implementation codes for WCNC 2023 conference paper "SDR System Design and Implementation on Delay-Doppler Communications and Sensing"

_Only SDR transceiver and signal generation design is giving in this project, the channel estimation and signal detection are not included!_

## Introduction
The orthogonal time frequency space (OTFS) technique is a promising modulation scheme with great advantages in channel delay and Doppler shifts. OTFS technique adopts a novel two-dimensional (2D) modulation technique that encodes information symbols in the delay-Doppler (DD) domain instead of the conventional time-frequency (TF) domain

![figure](./figures/OTFS.png)

## System Model
![figure](./figures/system.jpg)

## Channel Input-Output Relation
Before introducing pilot base Delay-Doppler channel emulator, we need to explain the DD domain input-output relation. As mentioned in the previous slides, after applying inverse symplectic FFT and Heisenberg transform to the DD domain, we can acquire time domain signal. Then the time domain signal interfered by the wireless channel and carry the channel state information. 

To inverse this process, we can apply wigner transform and symplectic FFT. However, instead of computing the complex time domain channel response and the domains transform, using DD domain input-output relation directly is computation-saving and more straightforward. 

![figure](./figures/inputoutput.png)
The DD domain input-output relation is basically the 2D circular convolution between input DD grid $X^{DD}$ and effective DD domain channel response $\Gamma$.  
The channel response consists of channel gain $h$, Initial phase $\phi$, and delay $l$ and doppler $k$ index of each path $p$

We use $\Gamma$ to represent the channel response and use $\Xi$ to represent doppler domain filter. 
The magnitude of the $\Xi$ just like the $sinc$ function. The non-integer point is non-zero, that is why the fractional doppler 
Will spread the power to the entire doppler taps.

![figure](./figures/inputoutputEqu.png)
## Channel Emulator

![figure](./figures/emulator.png)

![figure](./figures/emulated%20result.png)