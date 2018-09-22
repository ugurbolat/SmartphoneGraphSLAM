function [ psi, theta, phi ] = Quarternion2Euler( q1, q2, q3 )

q0 = (q1.^2 + q2.^2 + q3.^2);

mag_bigger_than_1_index = find(q0>1);
q0(mag_bigger_than_1_index) = 0.99999;
q0 = sqrt(1-q0);

psi = atan2( -2*(q2.*q3 - q0.*q1) , q0.*q0 - q1.*q1 - q2.*q2 + q3.*q3); 
theta = asin( 2*(q1.*q3 + q0.*q2));
phi = atan2( 2*(-q1.*q2 + q0.*q3) , q0.*q0 + q1.*q1 - q2.*q2 - q3.*q3);
 
psi = 180/pi * psi;
theta = 180/pi * theta;
phi = 180/pi * phi;

end

