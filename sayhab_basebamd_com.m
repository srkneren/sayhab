

% Created by Serkan EREN
% ELM 365 Matlab Project

number_of_bits = 10000000

%A^2T = 4 
Eb = 1
A2T = Eb*4
a1 = A2T/4
a2 = -A2T/4
Eh = A2T/2
Ps1 = 1/3
Ps2 = 2/3
Ed = A2T/2
% Snr values as Decibel
N0_db = [0:15]
% convert Snr db to decimal
N0 = 1./ (10.^(N0_db/10)*Eb);

%randsrc create bits with given probability
ai = randsrc(1,number_of_bits,[0 1;2/3 1/3]);

s_tilda = zeros(1,number_of_bits)
Pb = []
for i=N0
    var = i.*Eh./2;
    gama = var*log(Ps2/Ps1)/(a1-a2) + (a1+a2)/2 ;
    %noise distrubition N(0,Var), used equation Y = alfa*X ---> var = alfa^2 
    n0 = randn(1,number_of_bits).*sqrt(var);
    %ai is vector of bits
    s = randsrc(1,number_of_bits,[0 1;2/3 1/3]);
    %I create s_temp because I will use it after comperison
    % I want to store it
    s_temp = s;
    %logic 1 already a1=1, dont need replace , replace 0 to a2=-1
    s( s == 0 ) = a2;
    z = s+n0;
    %desicion: compare with gama, if bigger make 1,if not make 0
    z(z >= gama) = 1 ;
    z(z < gama) = 0 ;
    %exit of comperator
    s_tilda = z;
    %if values (s_temp == s_tilda) make errors to 1,else zero 
    errors = s_temp == s_tilda ;
    %chech there are how many error (zero represent error)
    
    number_of_error = sum(errors == 0)
    %append Pb values to array Pb = number_of_error/number_of_bits 
    Pb = [Pb number_of_error/number_of_bits];
end 

%Theorytically solution 
Pb_theoric = qfunc(sqrt(Ed./(2*N0)))

%plot results
figure(1);
semilogy(N0_db,Pb,"-*")
title('Simülasyon BHO Eğrisi');
xlabel('SNRdb');
ylabel('BER');
grid on

figure(2)
semilogy(N0_db,Pb_theoric,"-*")
title('Teorik BHO Eğrisi');
xlabel('SNRdb');
ylabel('BER');
grid on

figure(3)
semilogy(N0_db,Pb,N0_db,Pb_theoric,'*-');...Teorik ve hesaplanan Pb grafiği kıyaslama
xlabel('SNRdb')
ylabel('Pb')
grid on
legend('Teorik Eğri','Simülasyon Eğrisi')
title('Teorik eğri vs Simülasyon Eğrisi')



