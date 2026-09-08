*Defectfree 

.param TEMP=27  
.include /home/vlsi/Desktop/my_work/CNFET.lib

* CNFET Parameters
.param Ccsd=0  CoupleRatio=0
.param m_cnt=1  Efo=0.6
.param Wg=0  Cb=40e-12
.param Lg=32e-9  Lgef=100e-9
.param Vfn=0  Vfp=0
.param m=13  n=0
.param Hox=4e-9  Kox=16
 

* Power Supply
Vdd1 vdd1 Gnd 0.7V
Vin1 in1 Gnd PULSE(0 0.7 0n 0.15n 0.15n 6n 10n)
* CNFET Circuit
X11 aa1 in1 vdd1 vdd1 PCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  Kgate='Kox' Tox='Hox' Csub='Cb' Vfbp='Vfp' Dout=1  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3  
X21 aa1 in1 Gnd Gnd NCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  Kgate='Kox' Tox='Hox' Csub='Cb' Vfbn='Vfn' Dout=1  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3   
*Contact Resistance
Rc1 aa1 a1 200 

* Load capacitances
Cload1 out1 Gnd 200a
Cload2 out2 Gnd 200a

* Coupling capacitance between TSVs
Cui a1 a2 2.4449a
Cub out1 out2 2.4427a

* Substrate resistance and capacitance
Rsi g1 g2 0.6399u
Csi g1 g2 6.7423a

* TSV resistances
Rtsv1 a1 b1 11.64695
Rtsv2 d1 out1 11.64695
Rtsv3 a2 b2 11.64695
Rtsv4 d2 out2 11.64695

* TSV inductances
Ltsv1 b1 c1 8.998f 
Ltsv2 c1 d1 8.998f 
Ltsv3 b2 c2 8.998f 
Ltsv4 c2 d2 8.998f 

* TSV capacitances to ground
Ctsv1 c1 g1 117.588a
Ctsv2 c2 g2 117.588a



* Simulation control
.tran 0.01n 60n

*Peak noise 
.measure TRAN peak_noise_out1 MAX V(out2) from=0ps to=10ns
* Propagation Delay Measurements
* Compute midpoints
.measure tran Vin1_max MAX v(in1) from=0ps to=10ns
.measure tran Vin1_min MIN v(in1) from=0ps to=10ns
.measure tran Vin1_mid PARAM='(Vin1_max + Vin1_min)/2'

.measure tran Vout1_max MAX v(out1) from=0ps to=10ns
.measure tran Vout1_min MIN v(out1) from=0ps to=10ns
.measure tran Vout1_mid PARAM='(Vout1_max + Vout1_min)/2'

* Propagation Delay Measurements
.measure tran tpLH1 trig v(in1) val='Vin1_mid' rise=1 targ v(out1) val='Vout1_mid' fall=1
.measure tran tpHL1 trig v(in1) val='Vin1_mid' fall=1 targ v(out1) val='Vout1_mid' rise=1
.measure TRAN t_propagation_delay1 PARAM = '(abs(tpLH1) + abs(tpHL1)) / 2' 

* Plot Waveforms
.plot V(in1) V(out1) V(in2) V(out2)  

.option PROBE POST=2 MEASOUT 
 .option measform=3
.option measfile=1
.end
