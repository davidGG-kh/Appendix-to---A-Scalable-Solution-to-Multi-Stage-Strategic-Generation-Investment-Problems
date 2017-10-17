$ontext
A Scalable Solution to Multi-Stage Strategic Generation Investment Problems
Copyright (C) 2017 Vladimir Dvorkin

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
$offtext
$eolcom //
option iterlim=999999999;           // avoid limit on iterations
option reslim=999999999;            // timelimit for solver in sec.
option optcr=0;                     // gap tolerance
option solprint=off;                // include solution print in .lst file
option limrow=0;                    // limit number of rows in .lst file
option limcol=0;                    // limit number of columns in .lst file
option decimals=1;                  // defines decimals in output file
option mip=cplex;
option MIQCP=cplex;
//--------------------------------------------------------------------

Sets
t        'time period'                                           /t1*t2/
h        'operating conditions'                                  /h1*h5/
k        'market scenarios'                                      /k1*k9/
gamma    'long-term scenarios'                                   /gamma1*gamma18/
e        'existing units'                                        /e1*e2/
e_g(e)   'existing conventional units'                           /e1*e1/
e_w(e)   'existing wind units'                                   /e2*e2/
c        'candidate units'                                       /c1*c5/
c_g(c)   'candidate conventional units'                          /c1*c3/
c_w(c)   'candidate wind units'                                  /c4*c5/
r        'rival units'                                           /r1*r12/
r_g(r)   'rival conventional units'                              /r1*r11/
r_w(r)   'rival wind units'                                      /r12*r12/
d        'demand units'                                          /d1*d1/
y        'SOS-1 set'                                             /y1*y2/
b        'Demand blocks'                                         /b1*b10/
DATA_rival        'data set'                                     /P_R_max_data,C_R_data/
DATA_ex           'data set'                                     /X_E_max,C_E_data/
DATA_Oper         'data set'                                     /North,South,hours,demand/
PH_iter           'PH iteration counter'                         /PH1*PH500/
;
Alias(t,tau);
Alias(gamma,gamma_pr);
Alias(k,k_pr);
*** Import rivals data
Table DATA_rivals(r,DATA_rival)
$ondelim
$include rival_generators.csv
$offdelim
display DATA_rivals;
*** Import existing units data
Table DATA_exist(e,DATA_ex)
$ondelim
$include existing_generators.csv
$offdelim
display DATA_exist;

***** Demand data
Parameter P_D_max_data(t,gamma,d,b)      'Actual power capacity of demand units';
P_D_max_data(t,gamma,d,b)=250;
P_D_max_data('t2','gamma1',d,b)=P_D_max_data('t1','gamma1',d,b)*1.2;
P_D_max_data('t2','gamma2',d,b)=P_D_max_data('t1','gamma1',d,b)*1.2;
P_D_max_data('t2','gamma3',d,b)=P_D_max_data('t1','gamma1',d,b)*1.2;
P_D_max_data('t2','gamma4',d,b)=P_D_max_data('t1','gamma1',d,b)*1.2;
P_D_max_data('t2','gamma5',d,b)=P_D_max_data('t1','gamma1',d,b)*1.2;
P_D_max_data('t2','gamma6',d,b)=P_D_max_data('t1','gamma1',d,b)*1.2;
P_D_max_data('t2','gamma7',d,b)=P_D_max_data('t1','gamma1',d,b)*1.0;
P_D_max_data('t2','gamma8',d,b)=P_D_max_data('t1','gamma1',d,b)*1.0;
P_D_max_data('t2','gamma9',d,b)=P_D_max_data('t1','gamma1',d,b)*1.0;
P_D_max_data('t2','gamma10',d,b)=P_D_max_data('t1','gamma1',d,b)*1.0;
P_D_max_data('t2','gamma11',d,b)=P_D_max_data('t1','gamma1',d,b)*1.0;
P_D_max_data('t2','gamma12',d,b)=P_D_max_data('t1','gamma1',d,b)*1.0;
P_D_max_data('t2','gamma13',d,b)=P_D_max_data('t1','gamma1',d,b)*0.8;
P_D_max_data('t2','gamma14',d,b)=P_D_max_data('t1','gamma1',d,b)*0.8;
P_D_max_data('t2','gamma15',d,b)=P_D_max_data('t1','gamma1',d,b)*0.8;
P_D_max_data('t2','gamma16',d,b)=P_D_max_data('t1','gamma1',d,b)*0.8;
P_D_max_data('t2','gamma17',d,b)=P_D_max_data('t1','gamma1',d,b)*0.8;
P_D_max_data('t2','gamma18',d,b)=P_D_max_data('t1','gamma1',d,b)*0.8;
Display P_D_max_data;

Parameter b_D_data(t,k,d,b)              'Utility of demand units';
b_D_data(t,k,d,b)=100-ord(b)*7;
b_D_data(t,'k1',d,b)=b_D_data(t,'k9',d,b)*1.1;
b_D_data(t,'k2',d,b)=b_D_data(t,'k9',d,b)*1.1;
b_D_data(t,'k3',d,b)=b_D_data(t,'k9',d,b)*1.1;
b_D_data(t,'k4',d,b)=b_D_data(t,'k9',d,b)*1.0;
b_D_data(t,'k5',d,b)=b_D_data(t,'k9',d,b)*1.0;
b_D_data(t,'k6',d,b)=b_D_data(t,'k9',d,b)*1.0;
b_D_data(t,'k7',d,b)=b_D_data(t,'k9',d,b)*0.9;
b_D_data(t,'k8',d,b)=b_D_data(t,'k9',d,b)*0.9;
b_D_data(t,'k9',d,b)=b_D_data(t,'k4',d,b)*0.9;
Display b_D_data;

***** Existing units of the strategic producer
Parameter X_E_max(e)                     'Power capacity of exisiting units';
* Conventional generators
Loop(e,
         IF(ord(e)<2,
                  X_E_max(e) = DATA_exist(e,'X_E_max');
         );
);
* Wind generators
X_E_max('e2')=0;

Parameter C_E_data(t,gamma,e)            'Generating costs of existing units';
* Conventional generators
Loop(e,
         IF(ord(e)<2,
                  C_E_data(t,gamma,e) = DATA_exist(e,'C_E_data');
         );
);
* Wind generators
C_E_data(t,gamma,'e2')=0;
Display X_E_max, C_E_data;

****** Rival units
Parameter P_R_max_data(t,gamma,r)        'Power capacity of rival units';
* Conventional generators
Loop(r,
         IF(ord(r)<12,
                  P_R_max_data(t,gamma,r) = DATA_rivals(r,'P_R_max_data');
         );
);
* Wind power generators
P_R_max_data(t,'gamma1','r12') = 100;
P_R_max_data(t,'gamma2','r12') = 500;
P_R_max_data(t,'gamma3','r12') = 100;
P_R_max_data(t,'gamma4','r12') = 500;
P_R_max_data(t,'gamma5','r12') = 100;
P_R_max_data(t,'gamma6','r12') = 500;
P_R_max_data(t,'gamma7','r12') = 100;
P_R_max_data(t,'gamma8','r12') = 500;
P_R_max_data(t,'gamma9','r12') = 100;
P_R_max_data(t,'gamma10','r12') = 500;
P_R_max_data(t,'gamma11','r12') = 100;
P_R_max_data(t,'gamma12','r12') = 500;
P_R_max_data(t,'gamma13','r12') = 100;
P_R_max_data(t,'gamma14','r12') = 500;
P_R_max_data(t,'gamma15','r12') = 100;
P_R_max_data(t,'gamma16','r12') = 500;
P_R_max_data(t,'gamma17','r12') = 100;
P_R_max_data(t,'gamma18','r12') = 500;

Display P_R_max_data;
Parameter C_R_data(t,gamma,k,r)          'Generating costs of rival units';
* Conventional generators
Loop(r,
         IF(ord(r)<12,
                  C_R_data(t,gamma,k,r) = DATA_rivals(r,'C_R_data');
         );
);
* Wind power generators
C_R_data(t,gamma,k,'r12') = 0;
C_R_data(t,gamma,'k1',r)=C_R_data(t,gamma,'k9',r)*1.1;
C_R_data(t,gamma,'k2',r)=C_R_data(t,gamma,'k9',r)*1.0;
C_R_data(t,gamma,'k3',r)=C_R_data(t,gamma,'k9',r)*0.9;
C_R_data(t,gamma,'k4',r)=C_R_data(t,gamma,'k9',r)*1.1;
C_R_data(t,gamma,'k5',r)=C_R_data(t,gamma,'k9',r)*1.0;
C_R_data(t,gamma,'k6',r)=C_R_data(t,gamma,'k9',r)*0.9;
C_R_data(t,gamma,'k7',r)=C_R_data(t,gamma,'k9',r)*1.1;
C_R_data(t,gamma,'k8',r)=C_R_data(t,gamma,'k9',r)*1.0;
C_R_data(t,gamma,'k9',r)=C_R_data(t,gamma,'k2',r)*0.9;
Display C_R_data;

****** Investment data
Parameter X_C_max(c)                     'Power capacity of candidate units';
X_C_max(c)=500;

Parameter C_C_data(t,gamma,c)            'Generating costs of candidate units';
C_C_data(t,gamma,'c1')=12;
C_C_data(t,gamma,'c2')=9;
C_C_data(t,gamma,'c3')=6.02;
C_C_data(t,gamma,'c4')=0;
C_C_data(t,gamma,'c5')=0;

Parameter C_inv_data(t,gamma,c)          'Investment costs of candidate units';
C_inv_data(t,gamma,'c1')=100000;
C_inv_data(t,gamma,'c2')=210000;
C_inv_data(t,gamma,'c3')=20000000;
C_inv_data(t,gamma,'c4')=470000;
C_inv_data(t,gamma,'c5')=310000;

C_inv_data('t2','gamma1','c4')=C_inv_data('t1','gamma1','c4')*1.0;
C_inv_data('t2','gamma2','c4')=C_inv_data('t1','gamma1','c4')*1.0;
C_inv_data('t2','gamma3','c4')=C_inv_data('t1','gamma1','c4')*0.8;
C_inv_data('t2','gamma4','c4')=C_inv_data('t1','gamma1','c4')*0.8;
C_inv_data('t2','gamma5','c4')=C_inv_data('t1','gamma1','c4')*0.6;
C_inv_data('t2','gamma6','c4')=C_inv_data('t1','gamma1','c4')*0.6;
C_inv_data('t2','gamma7','c4')=C_inv_data('t1','gamma1','c4')*1.0;
C_inv_data('t2','gamma8','c4')=C_inv_data('t1','gamma1','c4')*1.0;
C_inv_data('t2','gamma9','c4')=C_inv_data('t1','gamma1','c4')*0.8;
C_inv_data('t2','gamma10','c4')=C_inv_data('t1','gamma1','c4')*0.8;
C_inv_data('t2','gamma11','c4')=C_inv_data('t1','gamma1','c4')*0.6;
C_inv_data('t2','gamma12','c4')=C_inv_data('t1','gamma1','c4')*0.6;
C_inv_data('t2','gamma13','c4')=C_inv_data('t1','gamma1','c4')*1.0;
C_inv_data('t2','gamma14','c4')=C_inv_data('t1','gamma1','c4')*1.0;
C_inv_data('t2','gamma15','c4')=C_inv_data('t1','gamma1','c4')*0.8;
C_inv_data('t2','gamma16','c4')=C_inv_data('t1','gamma1','c4')*0.8;
C_inv_data('t2','gamma17','c4')=C_inv_data('t1','gamma1','c4')*0.6;
C_inv_data('t2','gamma18','c4')=C_inv_data('t1','gamma1','c4')*0.6;

C_inv_data('t2','gamma1','c5')=C_inv_data('t1','gamma1','c5')*1.0;
C_inv_data('t2','gamma2','c5')=C_inv_data('t1','gamma1','c5')*1.0;
C_inv_data('t2','gamma3','c5')=C_inv_data('t1','gamma1','c5')*0.8;
C_inv_data('t2','gamma4','c5')=C_inv_data('t1','gamma1','c5')*0.8;
C_inv_data('t2','gamma5','c5')=C_inv_data('t1','gamma1','c5')*0.6;
C_inv_data('t2','gamma6','c5')=C_inv_data('t1','gamma1','c5')*0.6;
C_inv_data('t2','gamma7','c5')=C_inv_data('t1','gamma1','c5')*1.0;
C_inv_data('t2','gamma8','c5')=C_inv_data('t1','gamma1','c5')*1.0;
C_inv_data('t2','gamma9','c5')=C_inv_data('t1','gamma1','c5')*0.8;
C_inv_data('t2','gamma10','c5')=C_inv_data('t1','gamma1','c5')*0.8;
C_inv_data('t2','gamma11','c5')=C_inv_data('t1','gamma1','c5')*0.6;
C_inv_data('t2','gamma12','c5')=C_inv_data('t1','gamma1','c5')*0.6;
C_inv_data('t2','gamma13','c5')=C_inv_data('t1','gamma1','c5')*1.0;
C_inv_data('t2','gamma14','c5')=C_inv_data('t1','gamma1','c5')*1.0;
C_inv_data('t2','gamma15','c5')=C_inv_data('t1','gamma1','c5')*0.8;
C_inv_data('t2','gamma16','c5')=C_inv_data('t1','gamma1','c5')*0.8;
C_inv_data('t2','gamma17','c5')=C_inv_data('t1','gamma1','c5')*0.6;
C_inv_data('t2','gamma18','c5')=C_inv_data('t1','gamma1','c5')*0.6;

Display C_inv_data;

Parameter I_max(t)               'Investment budget';
I_max(t)=150000000;

****** Scenario conditions
Parameter pi_M(k)                'Probability of market scenarios';
pi_M(k)=1/card(k);

Parameter pi_L(gamma)            'Probability o flong-term scenarios';
pi_L('gamma1')=0.03;
pi_L('gamma2')=0.03;
pi_L('gamma3')=0.06;
pi_L('gamma4')=0.06;
pi_L('gamma5')=0.06;
pi_L('gamma6')=0.06;
pi_L('gamma7')=0.05;
pi_L('gamma8')=0.05;
pi_L('gamma9')=0.10;
pi_L('gamma10')=0.10;
pi_L('gamma11')=0.10;
pi_L('gamma12')=0.10;
pi_L('gamma13')=0.02;
pi_L('gamma14')=0.02;
pi_L('gamma15')=0.04;
pi_L('gamma16')=0.04;
pi_L('gamma17')=0.04;
pi_L('gamma18')=0.04;
Display pi_L;

Parameter N_MC(h)                'Number of hours for each market conditions';
N_MC('h1')=1036*3;
N_MC('h2')=4306*3;
N_MC('h3')=443*3;
N_MC('h4')=955*3;
N_MC('h5')=2020*3;

Parameter K_CF_E(h,e_w)          'Capacity factor of existing wind power units';
K_CF_E('h1',e_w)=0.1223;
K_CF_E('h2',e_w)=0.1415;
K_CF_E('h3',e_w)=0.6968;
K_CF_E('h4',e_w)=0.1307;
K_CF_E('h5',e_w)=0.7671;

Parameter K_CF_R(h,r_w)          'Capacity factor of existing wind power units';
K_CF_R('h1',r_w)=0.1223;
K_CF_R('h2',r_w)=0.1415;
K_CF_R('h3',r_w)=0.6968;
K_CF_R('h4',r_w)=0.1307;
K_CF_R('h5',r_w)=0.7671;

Parameter K_CF_C(h,c_w)          'Capacity factor of candidate wind power units';
K_CF_C('h1','c4')=0.1223;
K_CF_C('h2','c4')=0.1415;
K_CF_C('h3','c4')=0.6968;
K_CF_C('h4','c4')=0.1307;
K_CF_C('h5','c4')=0.7671;

K_CF_C('h1','c5')=0.4169;
K_CF_C('h2','c5')=0.0373;
K_CF_C('h3','c5')=0.6129;
K_CF_C('h4','c5')=0.7665;
K_CF_C('h5','c5')=0.0508;

Parameter K_DF(h)                'Demand factor';
K_DF('h1')=0.692;
K_DF('h2')=0.7107;
K_DF('h3')=0.7093;
K_DF('h4')=0.7292;
K_DF('h5')=0.73;

****** Non-anticipativity conditions
Parameter AM(t,gamma,k,gamma_pr,k_pr) 'non-anticipativity matrix';
AM(t,gamma,k,gamma_pr,k_pr)=0;
Loop((t,gamma,k,gamma_pr,k_pr),
         IF(ord(t)=1,
                 AM(t,gamma,k,gamma_pr,k_pr) = 1;
         );
         IF(ord(t)=2,
                 IF(ord(gamma)=ord(gamma_pr),
                         AM(t,gamma,k,gamma_pr,k_pr) = 1;
                 );

         );
);
Display AM;

Parameter Pr(t,gamma,k) 'Probability of an outcome at time period t';
Pr(t,gamma,k)=0;
Loop((t,gamma,k),
         IF(ord(t)=1,
                 Pr(t,gamma,k) = pi_L(gamma)*pi_M(k);
         );
         IF(ord(t)=2,
                 Pr(t,gamma,k) = pi_M(k);
         );
);
Display Pr;


****** Other-regards parameters
Scalar           chi_SoS         'Security of supply coefficient'        /1.05/;
Parameter        DR(t)           'Discount rate at year t';
DR(t)=0.1;
Parameter        a(t)            'Amortization rate';
a(t)=0.15;

***** Parameters to be updated for each long-term scenarios
Parameters
b_D(t,d,b)
P_D_max(t,d,b)
C_E(t,e)
P_R_max(t,r)
C_R(t,r)
C_C(t,c)
C_inv(t,c)
m_PH_model(t,c)
m_PH_LB_model(t,c)
X_C_avr_model(t,c)
;
Scalar rho /1000/;

****** Decision variables
****** Investment decisions
Positive variables
         X_C(t,c)                'Installed capacity of candidate unit c to be built';
****** Strategic behaviour variables
Positive Variables
         PP_E_max(e,t,h)         'Offering quantity of an exisitng unit'
         PP_C_max(c,t,h)         'Offering quantity of a cadidate unit'
         Beta_E(e,t,h)           'Offering price of an exisitng unit'
         Beta_C(c,t,h)           'Offering price of a cadidate unit'
;
Positive variables
         P_D(t,h,d,b)            'Scheduled demand quantity'
         P_R(t,h,r)              'Scheduled rival unit generaton quantity'
         P_E(t,h,e)              'Scheduled existing unit generaton quantity'
         P_C(t,h,c)              'Scheduled candidate unit generaton quantity'

         mu_D_l(t,h,d,b)
         mu_D_u(t,h,d,b)
         mu_R_l(t,h,r)
         mu_R_u(t,h,r)
         mu_E_l(t,h,e)
         mu_E_u(t,h,e)
         mu_C_l(t,h,c)
         mu_C_u(t,h,c)

Free variables
         z                       'Social welfare value'
         lambda_DA(t,h)          'Day-ahead electricity price'
;
SOS1 variables
         nu_D_l(t,h,d,b,y)
         nu_D_u(t,h,d,b,y)
         nu_R_l(t,h,r,y)
         nu_R_u(t,h,r,y)
         nu_E_l(t,h,e,y)
         nu_E_u(t,h,e,y)
         nu_C_l(t,h,c,y)
         nu_C_u(t,h,c,y)

;
Equations
         OBJ
         OBJ_PH
         OBJ_LB

         INV_X_C(t,c)
         INV_BUDGET(t)
         SoS(t,h)

         MAX_P_E_Conv(e_g,t,h)
         MAX_P_E_WP(e_w,t,h)
         MAX_P_C_Conv(c_g,t,h)
         MAX_P_C_WP(c_w,t,h)

         DA_PB(t,h)

         D_DA_MAX(t,h,d,b)
         R_DA_MAX_conv(t,h,r_g)
         R_DA_MAX_wp(t,h,r_w)
         E_DA_MAX(t,h,e)
         C_DA_MAX(t,h,c)

         STAT1(t,h,d,b)
         STAT2(t,h,r)
         STAT3(t,h,e)
         STAT4(t,h,c)

         SOS1_D_l(t,h,d,b)
         SOS2_D_l(t,h,d,b)
         SOS1_D_u(t,h,d,b)
         SOS2_D_u(t,h,d,b)
         SOS1_R_l(t,h,r)
         SOS2_R_l(t,h,r)
         SOS1_R_u_conv(t,h,r_g)
         SOS2_R_u_conv(t,h,r_g)
         SOS1_R_u_wp(t,h,r_w)
         SOS2_R_u_wp(t,h,r_w)
         SOS1_E_l(t,h,e)
         SOS2_E_l(t,h,e)
         SOS1_E_u(t,h,e)
         SOS2_E_u(t,h,e)
         SOS1_C_l(t,h,c)
         SOS2_C_l(t,h,c)
         SOS1_C_u(t,h,c)
         SOS2_C_u(t,h,c)
;
OBJ..
         sum(t,  1/(1+DR(t))**(ord(t))*(sum(h, N_MC(h)*(
                 - sum(e, C_E(t,e)*P_E(t,h,e))
                 - sum(c, C_C(t,c)*P_C(t,h,c))
                 + sum((d,b), b_D(t,d,b)*P_D(t,h,d,b))
                 - sum(r, C_R(t,r)*P_R(t,h,r))
                 - sum((d,b), mu_D_u(t,h,d,b)*P_D_max(t,d,b)*K_DF(h))
                 - sum(r_w, mu_R_u(t,h,r_w)*P_R_max(t,r_w)*K_CF_R(h,r_w))
                 - sum(r_g, mu_R_u(t,h,r_g)*P_R_max(t,r_g))))
                 -a(t)*sum(c, C_inv(t,c)*sum(tau$(ord(tau)<=ord(t)), X_C(tau,c))))) =E= z;

OBJ_PH..
         sum(t,  1/(1+DR(t))**(ord(t))*(sum(h, N_MC(h)*(
                 - sum(e, C_E(t,e)*P_E(t,h,e))
                 - sum(c, C_C(t,c)*P_C(t,h,c))
                 + sum((d,b), b_D(t,d,b)*P_D(t,h,d,b))
                 - sum(r, C_R(t,r)*P_R(t,h,r))
                 - sum((d,b), mu_D_u(t,h,d,b)*P_D_max(t,d,b)*K_DF(h))
                 - sum(r_w, mu_R_u(t,h,r_w)*P_R_max(t,r_w)*K_CF_R(h,r_w))
                 - sum(r_g, mu_R_u(t,h,r_g)*P_R_max(t,r_g))))
                 -a(t)*sum(c, C_inv(t,c)*sum(tau$(ord(tau)<=ord(t)), X_C(tau,c)))))
         - sum((t,c), m_PH_model(t,c)*X_C(t,c))
         - sum((t,c), rho/2*(X_C(t,c)-X_C_avr_model(t,c))*(X_C(t,c)-X_C_avr_model(t,c))) =E= z;

OBJ_LB..
         sum(t,  1/(1+DR(t))**(ord(t))*(sum(h, N_MC(h)*(
                 - sum(e, C_E(t,e)*P_E(t,h,e))
                 - sum(c, C_C(t,c)*P_C(t,h,c))
                 + sum((d,b), b_D(t,d,b)*P_D(t,h,d,b))
                 - sum(r, C_R(t,r)*P_R(t,h,r))
                 - sum((d,b), mu_D_u(t,h,d,b)*P_D_max(t,d,b)*K_DF(h))
                 - sum(r_w, mu_R_u(t,h,r_w)*P_R_max(t,r_w)*K_CF_R(h,r_w))
                 - sum(r_g, mu_R_u(t,h,r_g)*P_R_max(t,r_g))))
                 -a(t)*sum(c, C_inv(t,c)*sum(tau$(ord(tau)<=ord(t)), X_C(tau,c)))))
         - sum((t,c), m_PH_LB_model(t,c)*X_C(t,c)) =E= z;

INV_X_C(t,c)..
         X_C(t,c) =L= X_C_max(c);

INV_BUDGET(t)..
         sum(c, X_C(t,c)*C_inv(t,c)) =L= I_max(t);

SoS(t,h)..
         sum(e, PP_E_max(e,t,h)) + sum(c, PP_C_max(c,t,h)) + sum(r, P_R_max(t,r)) =G= sum((d,b), P_D_max(t,d,b))*K_DF(h)*chi_SoS;

MAX_P_E_Conv(e_g,t,h)..
         PP_E_max(e_g,t,h) =L= X_E_max(e_g);

MAX_P_E_WP(e_w,t,h)..
         PP_E_max(e_w,t,h) =L= X_E_max(e_w)*K_CF_E(h,e_w);

MAX_P_C_Conv(c_g,t,h)..
         PP_C_max(c_g,t,h) =L= sum(tau$(ord(tau)<=ord(t)), X_C(tau,c_g));

MAX_P_C_WP(c_w,t,h)..
         PP_C_max(c_w,t,h) =L= sum(tau$(ord(tau)<=ord(t)), X_C(tau,c_w))*K_CF_C(h,c_w);

DA_PB(t,h)..
         sum(r, P_R(t,h,r)) + sum(e, P_E(t,h,e)) + sum(c, P_C(t,h,c)) - sum((d,b), P_D(t,h,d,b)) =E= 0;

D_DA_MAX(t,h,d,b)..
         P_D(t,h,d,b) =L= P_D_max(t,d,b)*K_DF(h);

R_DA_MAX_conv(t,h,r_g)..
         P_R(t,h,r_g) =L= P_R_max(t,r_g);

R_DA_MAX_wp(t,h,r_w)..
         P_R(t,h,r_w) =L= P_R_max(t,r_w)*K_CF_R(h,r_w);

E_DA_MAX(t,h,e)..
         P_E(t,h,e) =L= PP_E_max(e,t,h);

C_DA_MAX(t,h,c)..
         P_C(t,h,c) =L= PP_C_max(c,t,h);

STAT1(t,h,d,b)..
         -b_D(t,d,b) + lambda_DA(t,h) + mu_D_u(t,h,d,b) - mu_D_l(t,h,d,b) =E= 0;

STAT2(t,h,r)..
         C_R(t,r) - lambda_DA(t,h) + mu_R_u(t,h,r) - mu_R_l(t,h,r) =E= 0;

STAT3(t,h,e)..
         Beta_E(e,t,h) - lambda_DA(t,h) + mu_E_u(t,h,e) - mu_E_l(t,h,e) =E= 0;

STAT4(t,h,c)..
         Beta_C(c,t,h) - lambda_DA(t,h) + mu_C_u(t,h,c) - mu_C_l(t,h,c)  =E= 0;

SOS1_D_l(t,h,d,b)..
         nu_D_l(t,h,d,b,'y1') + nu_D_l(t,h,d,b,'y2') =E= mu_D_l(t,h,d,b) + P_D(t,h,d,b);

SOS2_D_l(t,h,d,b)..
         nu_D_l(t,h,d,b,'y1') - nu_D_l(t,h,d,b,'y2') =E= mu_D_l(t,h,d,b) - P_D(t,h,d,b);

SOS1_D_u(t,h,d,b)..
         nu_D_u(t,h,d,b,'y1') + nu_D_u(t,h,d,b,'y2') =E= mu_D_u(t,h,d,b) + [P_D_max(t,d,b)*K_DF(h) - P_D(t,h,d,b)];

SOS2_D_u(t,h,d,b)..
         nu_D_u(t,h,d,b,'y1') - nu_D_u(t,h,d,b,'y2') =E= mu_D_u(t,h,d,b) - [P_D_max(t,d,b)*K_DF(h) - P_D(t,h,d,b)];

SOS1_R_l(t,h,r)..
         nu_R_l(t,h,r,'y1') + nu_R_l(t,h,r,'y2') =E= mu_R_l(t,h,r) + P_R(t,h,r);

SOS2_R_l(t,h,r)..
         nu_R_l(t,h,r,'y1') - nu_R_l(t,h,r,'y2') =E= mu_R_l(t,h,r) - P_R(t,h,r);

SOS1_R_u_conv(t,h,r_g)..
         nu_R_u(t,h,r_g,'y1') + nu_R_u(t,h,r_g,'y2') =E= mu_R_u(t,h,r_g) + [P_R_max(t,r_g) - P_R(t,h,r_g)];

SOS2_R_u_conv(t,h,r_g)..
         nu_R_u(t,h,r_g,'y1') - nu_R_u(t,h,r_g,'y2') =E= mu_R_u(t,h,r_g) - [P_R_max(t,r_g) - P_R(t,h,r_g)];

SOS1_R_u_wp(t,h,r_w)..
         nu_R_u(t,h,r_w,'y1') + nu_R_u(t,h,r_w,'y2') =E= mu_R_u(t,h,r_w) + [P_R_max(t,r_w)*K_CF_R(h,r_w) - P_R(t,h,r_w)];

SOS2_R_u_wp(t,h,r_w)..
         nu_R_u(t,h,r_w,'y1') - nu_R_u(t,h,r_w,'y2') =E= mu_R_u(t,h,r_w) - [P_R_max(t,r_w)*K_CF_R(h,r_w) - P_R(t,h,r_w)];

SOS1_E_l(t,h,e)..
         nu_E_l(t,h,e,'y1') + nu_E_l(t,h,e,'y2') =E= mu_E_l(t,h,e) + P_E(t,h,e);

SOS2_E_l(t,h,e)..
         nu_E_l(t,h,e,'y1') - nu_E_l(t,h,e,'y2') =E= mu_E_l(t,h,e) - P_E(t,h,e);

SOS1_E_u(t,h,e)..
         nu_E_u(t,h,e,'y1') + nu_E_u(t,h,e,'y2') =E= mu_E_u(t,h,e) + [PP_E_max(e,t,h) - P_E(t,h,e)];

SOS2_E_u(t,h,e)..
         nu_E_u(t,h,e,'y1') - nu_E_u(t,h,e,'y2') =E= mu_E_u(t,h,e) - [PP_E_max(e,t,h) - P_E(t,h,e)];

SOS1_C_l(t,h,c)..
         nu_C_l(t,h,c,'y1') + nu_C_l(t,h,c,'y2') =E= mu_C_l(t,h,c) + P_C(t,h,c);

SOS2_C_l(t,h,c)..
         nu_C_l(t,h,c,'y1') - nu_C_l(t,h,c,'y2') =E= mu_C_l(t,h,c) - P_C(t,h,c);

SOS1_C_u(t,h,c)..
         nu_C_u(t,h,c,'y1') + nu_C_u(t,h,c,'y2') =E= mu_C_u(t,h,c) + [PP_C_max(c,t,h) - P_C(t,h,c)];

SOS2_C_u(t,h,c)..
         nu_C_u(t,h,c,'y1') - nu_C_u(t,h,c,'y2') =E= mu_C_u(t,h,c) - [PP_C_max(c,t,h) - P_C(t,h,c)];

Model Scenario_specific /
OBJ
INV_X_C
INV_BUDGET
SoS
MAX_P_E_Conv
MAX_P_E_WP
MAX_P_C_Conv
MAX_P_C_WP
DA_PB
D_DA_MAX
R_DA_MAX_conv
R_DA_MAX_wp
E_DA_MAX
C_DA_MAX
STAT1
STAT2
STAT3
STAT4
SOS1_D_l
SOS2_D_l
SOS1_D_u
SOS2_D_u
SOS1_R_l
SOS2_R_l
SOS1_R_u_conv
SOS2_R_u_conv
SOS1_R_u_wp
SOS2_R_u_wp
SOS1_E_l
SOS2_E_l
SOS1_E_u
SOS2_E_u
SOS1_C_l
SOS2_C_l
SOS1_C_u
SOS2_C_u
/;
Model Scenario_specific_PH /
OBJ_PH
INV_X_C
INV_BUDGET
SoS
MAX_P_E_Conv
MAX_P_E_WP
MAX_P_C_Conv
MAX_P_C_WP
DA_PB
D_DA_MAX
R_DA_MAX_conv
R_DA_MAX_wp
E_DA_MAX
C_DA_MAX
STAT1
STAT2
STAT3
STAT4
SOS1_D_l
SOS2_D_l
SOS1_D_u
SOS2_D_u
SOS1_R_l
SOS2_R_l
SOS1_R_u_conv
SOS2_R_u_conv
SOS1_R_u_wp
SOS2_R_u_wp
SOS1_E_l
SOS2_E_l
SOS1_E_u
SOS2_E_u
SOS1_C_l
SOS2_C_l
SOS1_C_u
SOS2_C_u
/;
Model Scenario_specific_PH_LB /
OBJ_LB
INV_X_C
INV_BUDGET
SoS
MAX_P_E_Conv
MAX_P_E_WP
MAX_P_C_Conv
MAX_P_C_WP
DA_PB
D_DA_MAX
R_DA_MAX_conv
R_DA_MAX_wp
E_DA_MAX
C_DA_MAX
STAT1
STAT2
STAT3
STAT4
SOS1_D_l
SOS2_D_l
SOS1_D_u
SOS2_D_u
SOS1_R_l
SOS2_R_l
SOS1_R_u_conv
SOS2_R_u_conv
SOS1_R_u_wp
SOS2_R_u_wp
SOS1_E_l
SOS2_E_l
SOS1_E_u
SOS2_E_u
SOS1_C_l
SOS2_C_l
SOS1_C_u
SOS2_C_u
/;

$onecho > cplex.opt
threads 3
$offecho
Scenario_specific.optfile=1;

$onecho > cplex.opt
threads 3
$offecho
Scenario_specific_PH.optfile=1;

$onecho > cplex.opt
threads 3
$offecho
Scenario_specific_PH_LB.optfile=1;


Parameter Save_X_C(PH_iter,t,gamma,k,c);
Parameter Save_X_C_avr(PH_iter,t,gamma,k,c);
Parameter m_PH(PH_iter,t,gamma,k,c);
Parameter Penalty(PH_iter,t,gamma,k,c);
Parameter D_LB(PH_iter,gamma,k);
Parameter Lower_bound(PH_iter);
Parameter D_UB(PH_iter,gamma,k);
Parameter Upper_bound(PH_iter);
Parameter g(PH_iter,t,gamma,k,c);
Parameter Converge;
Converge=0;
Parameter Conv(PH_iter,t,gamma,k,c);




* Extract data to check the quality of the solution at each iteration

Parameter COMP1(PH_iter,t,gamma,h,k,d,b);
Parameter COMP2(PH_iter,t,gamma,h,k,d,b);
Parameter COMP3(PH_iter,t,gamma,h,k,r);
Parameter COMP4(PH_iter,t,gamma,h,k,r_g);
Parameter COMP5(PH_iter,t,gamma,h,k,r_w);
Parameter COMP6(PH_iter,t,gamma,h,k,e);
Parameter COMP7(PH_iter,t,gamma,h,k,e);
Parameter COMP8(PH_iter,t,gamma,h,k,c);
Parameter COMP9(PH_iter,t,gamma,h,k,c);
Parameter Save_Lambda_DA(PH_iter,t,gamma,k,c,h);
Parameter Profit_non_lin(PH_iter,gamma,k);

Scalar epsilon /0.5/;


Loop(PH_iter$(not Converge),
IF(ord(PH_iter)=1,
         Loop((k,gamma),
                 b_D(t,d,b)=b_D_data(t,k,d,b);
                 P_D_max(t,d,b)=P_D_max_data(t,gamma,d,b);
                 C_E(t,e)=C_E_data(t,gamma,e);
                 P_R_max(t,r)=P_R_max_data(t,gamma,r);
                 C_R(t,r)=C_R_data(t,gamma,k,r);
                 C_C(t,c)=C_C_data(t,gamma,c);
                 C_inv(t,c)=C_inv_data(t,gamma,c);

                 Solve Scenario_specific maximizing z using mip;
                 Save_X_C(PH_iter,t,gamma,k,c) = X_C.l(t,c);
                 D_UB(PH_iter,gamma,k) = z.l;
                 COMP1(PH_iter,t,gamma,h,k,d,b) = mu_D_l.l(t,h,d,b) * P_D.l(t,h,d,b);
                 COMP2(PH_iter,t,gamma,h,k,d,b) = mu_D_u.l(t,h,d,b) * [P_D_max(t,d,b)*K_DF(h) - P_D.l(t,h,d,b)];
                 COMP3(PH_iter,t,gamma,h,k,r) = mu_R_l.l(t,h,r) * P_R.l(t,h,r);
                 COMP4(PH_iter,t,gamma,h,k,r_g) = mu_R_u.l(t,h,r_g) * [P_R_max(t,r_g) - P_R.l(t,h,r_g)];
                 COMP5(PH_iter,t,gamma,h,k,r_w) = mu_R_u.l(t,h,r_w) * [P_R_max(t,r_w)*K_CF_R(h,r_w) - P_R.l(t,h,r_w)];
                 COMP6(PH_iter,t,gamma,h,k,e) = mu_E_l.l(t,h,e) * P_E.l(t,h,e);
                 COMP7(PH_iter,t,gamma,h,k,e) = mu_E_u.l(t,h,e) * [PP_E_max.l(e,t,h) - P_E.l(t,h,e)];
                 COMP8(PH_iter,t,gamma,h,k,c) = mu_C_l.l(t,h,c) * P_C.l(t,h,c);
                 COMP9(PH_iter,t,gamma,h,k,c) = mu_C_u.l(t,h,c) * [PP_C_max.l(c,t,h) - P_C.l(t,h,c)];
         );
*        Compute average of investment decisions
         Loop((t,gamma,k,c),
                  Save_X_C_avr(PH_iter,t,gamma,k,c)= sum((gamma_pr,k_pr)$AM(t,gamma,k,gamma_pr,k_pr), Pr(t,gamma_pr,k_pr)*Save_X_C(PH_iter,t,gamma_pr,k_pr,c))/sum((gamma_pr,k_pr)$AM(t,gamma,k,gamma_pr,k_pr), Pr(t,gamma_pr,k_pr));
         );
*        Compute PH multiplier
         Loop((t,gamma,k,c),
                 m_PH(PH_iter,t,gamma,k,c) =  rho*(Save_X_C(PH_iter,t,gamma,k,c)-Save_X_C_avr(PH_iter,t,gamma,k,c));
         );
*        Compute upper bound
         Upper_bound(PH_iter)=sum((gamma,k), pi_L(gamma)*pi_M(k)*D_UB(PH_iter,gamma,k));
);
IF(ord(PH_iter)>1,
         Loop((k,gamma),
                 b_D(t,d,b)=b_D_data(t,k,d,b);
                 P_D_max(t,d,b)=P_D_max_data(t,gamma,d,b);
                 C_E(t,e)=C_E_data(t,gamma,e);
                 P_R_max(t,r)=P_R_max_data(t,gamma,r);
                 C_R(t,r)=C_R_data(t,gamma,k,r);
                 C_C(t,c)=C_C_data(t,gamma,c);
                 C_inv(t,c)=C_inv_data(t,gamma,c);
                 Loop((t,c),
                         m_PH_model(t,c)=m_PH(PH_iter-1,t,gamma,k,c);
                         X_C_avr_model(t,c)=Save_X_C_avr(PH_iter-1,t,gamma,k,c);
                 );
                 Solve Scenario_specific_PH maximizing z using MIQCP;
                 Save_X_C(PH_iter,t,gamma,k,c) = X_C.l(t,c);
                 Save_Lambda_DA(PH_iter,t,gamma,k,c,h) = lambda_DA.l(t,h);
         );
*        Compute average of investment decisions
         Loop((t,gamma,k,c),
                  Save_X_C_avr(PH_iter,t,gamma,k,c)= sum((gamma_pr,k_pr)$AM(t,gamma,k,gamma_pr,k_pr), Pr(t,gamma_pr,k_pr)*Save_X_C(PH_iter,t,gamma_pr,k_pr,c))/sum((gamma_pr,k_pr)$AM(t,gamma,k,gamma_pr,k_pr), Pr(t,gamma_pr,k_pr));
         );
*        Compute PH multiplier
         Loop((t,gamma,k,c),
                 m_PH(PH_iter,t,gamma,k,c) =  m_PH(PH_iter-1,t,gamma,k,c) + rho*(Save_X_C(PH_iter,t,gamma,k,c)-Save_X_C_avr(PH_iter,t,gamma,k,c));
         );
*        Compute lower bound
         Loop((gamma,k),
                  b_D(t,d,b)=b_D_data(t,k,d,b);
                  P_D_max(t,d,b)=P_D_max_data(t,gamma,d,b);
                  C_E(t,e)=C_E_data(t,gamma,e);
                  P_R_max(t,r)=P_R_max_data(t,gamma,r);
                  C_R(t,r)=C_R_data(t,gamma,k,r);
                  C_C(t,c)=C_C_data(t,gamma,c);
                  C_inv(t,c)=C_inv_data(t,gamma,c);

                  m_PH_LB_model(t,c) =  m_PH(PH_iter,t,gamma,k,c);
                  Solve Scenario_specific_PH_LB maximizing z using MIP;
                  D_LB(PH_iter,gamma,k) = z.l;
         );
         Lower_bound(PH_iter)=sum(gamma, pi_L(gamma)* sum(k, pi_M(k)*D_LB(PH_iter,gamma,k)));
*        Compute upper bound
         Loop((gamma,k),
                  b_D(t,d,b)=b_D_data(t,k,d,b);
                  P_D_max(t,d,b)=P_D_max_data(t,gamma,d,b);
                  C_E(t,e)=C_E_data(t,gamma,e);
                  P_R_max(t,r)=P_R_max_data(t,gamma,r);
                  C_R(t,r)=C_R_data(t,gamma,k,r);
                  C_C(t,c)=C_C_data(t,gamma,c);
                  C_inv(t,c)=C_inv_data(t,gamma,c);

                 Loop((t,c),
                         X_C.LO(t,c) = Save_X_C(PH_iter,t,gamma,k,c);
                         X_C.UP(t,c) = Save_X_C(PH_iter,t,gamma,k,c);
                 );
                 Solve Scenario_specific maximizing z using MIP;
                 D_UB(PH_iter,gamma,k) = z.l;
                 Loop((t,c),
                         X_C.LO(t,c) = 0;
                         X_C.UP(t,c) = 300000;
                 );
         );
         Upper_bound(PH_iter)=sum((gamma,k), pi_L(gamma)*pi_M(k)*D_UB(PH_iter,gamma,k));

*        Check convergence
         Loop((t,gamma,k,c),
                 g(PH_iter,t,gamma,k,c) = Save_X_C(PH_iter,t,gamma,k,c) - Save_X_C_avr(PH_iter,t,gamma,k,c);
                 Conv(PH_iter,t,gamma,k,c)=1$(abs(g(PH_iter,t,gamma,k,c))<=epsilon);
         );
         Converge=1$(sum((t,gamma,k,c), Conv(PH_iter,t,gamma,k,c))=card(t)*card(gamma)*card(k)*card(c));
);
);
Display Save_X_C, Save_X_C_avr, Lower_bound, Upper_bound;
*Display COMP1,COMP2,COMP3,COMP4,COMP5,COMP6,COMP7,COMP8,COMP9;

Scalar tcomp, texec, telapsed;
tcomp = TimeComp;
texec = TimeExec;
telapsed = TimeElapsed;
Display tcomp, texec, telapsed;

****************Export results
File results_PH_LT_MS_All /results_PH_LT_MS_All.csv/;
results_PH_LT_MS_All.pc=5;
Put results_PH_LT_MS_All;
put "Investment decision per itteration"/;
Loop((t,gamma,k,c,PH_iter),
         put t.tl, gamma.tl, k.tl, c.tl, PH_iter.tl, Save_X_C(PH_iter,t,gamma,k,c)/
);
put "Lower bound of the objective function"/;
Loop(PH_iter,
         put PH_iter.tl, Lower_bound(PH_iter)/
);
put "Upper bound of the objective function"/;
Loop(PH_iter,
         put PH_iter.tl, Upper_bound(PH_iter)/
);
put "Time elapsed"/;
put  telapsed/;
putclose;
