# Power-System-Visual-Analysis-in-Matlab-Heatmap
This work has been developed as a solution to improve visual features in Matlab environment when it comes to Power Systems and the  idea is proposed by Prof. Gianfranco Chicco. 
Heatmap analysis returns visual result in terms of variable of interest such as line loading, losses, consumed and produced active power and voltages in nodes.
Running "BFS.m", a load flow algorithm is being launched (here a radial system with backward-forward-sweep) and the output results will be available such as bus voltages, Line loading, active and reactive power in buses and lines. These results as matrices are being demonstrated as figures like every conventional analysis, then a graphic visualization of the grid and analysis result is being appeared to give a quick and intuitive overview of the electrical quantities and its evolution during simulation time (here 24 hours with time step of 1 hour). Visual results are; 
* Active power generated as green circle with diameter proportional to its amplitude. 
* Active power load as red circle with diameter proportional to its amplitude. 
* Line loading as thickness of the line. 
* Thermal limit violation margin of line as line's color, blue indicates the line loading is much lower than its thermal 
limit bus color changes towards red as loading reaches the maximum limit value. 
* Both loading in percent and bus voltage in per unit scale are being shown by numerical values.
