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
Vdd2 vdd2 Gnd 0.7V
Vin1 in1 Gnd PULSE(0 0.7 0n 0.15n 0.15n 6n 10n)
Vin2 in2 Gnd PULSE(0.7 0 0n 0.15n 0.15n 6n 10n)
* CNFET Circuit
X11 aa1 in1 vdd1 vdd1 PCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  Kgate='Kox' Tox='Hox' Csub='Cb' Vfbp='Vfp' Dout=1  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3  
X21 aa1 in1 Gnd Gnd NCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  Kgate='Kox' Tox='Hox' Csub='Cb' Vfbn='Vfn' Dout=1  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3  
X12 aa2 in2 vdd2 vdd2 PCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  Kgate='Kox' Tox='Hox' Csub='Cb' Vfbp='Vfp' Dout=1  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3  
X22 aa2 in2 Gnd Gnd NCNFET Lch=Lg  Lgeff='Lgef' Lss=32e-9  Ldd=32e-9  Kgate='Kox' Tox='Hox' Csub='Cb' Vfbn='Vfn' Dout=1  Sout=0  Pitch=20e-9  n1=m  n2=n  tubes=3  
*Contact Resistance
Rc1 aa1 a1 200 
Rc2 aa2 a2 200



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

* Crosstalk Delay Measurements
* Midpoint for in2 and out2
.measure tran Vout2_max MAX v(out2) from=0ps to=10ns
.measure tran Vout2_min MIN v(out2) from=0ps to=10ns
.measure tran Vout2_mid PARAM='(Vout2_max + Vout2_min)/2'

.measure tran Vin2_max MAX v(in2) from=0ps to=10ns
.measure tran Vin2_min MIN v(in2) from=0ps to=10ns
.measure tran Vin2_mid PARAM='(Vin2_max + Vin2_min)/2'

* Crosstalk from in1 → out2
.measure tran xtalk_delay21_a trig v(in2) val='Vin2_mid' rise=1 targ v(out2) val='Vout2_mid' fall=1  
.measure tran xtalk_delay21_b trig v(in2) val='Vin2_mid' fall=1 targ v(out2) val='Vout2_mid' rise=1  
.measure TRAN t_crosstalk_delay21 PARAM = '(abs(xtalk_delay21_a) + abs(xtalk_delay21_b)) / 2'

* Plot Waveforms
.plot V(in1) V(out1) V(in2) V(out2)  

.option PROBE POST=2 MEASOUT 
 .option measform=3
.option measfile=1
.end  

