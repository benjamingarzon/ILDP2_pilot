data {
 //int<lower=1> N;
  int<lower=1> T;               
 // int<lower=1,upper=T> Tsubj[N];                 
  int<lower=1,upper=2> stimulus[T];     
 // real<lower=0,upper=1> rresponsetrial[N,T];  // indicates rresponseersed trials
  int shock[T];  // electric shocks 
  real response[T];  // electric shocks   

}

transformed data {
  vector[2] initV;  // initial values for response
  initV = rep_vector(0.0, 2);
}

parameters {
  // Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters  
  // vector[2] mu_p;  
  // vector<lower=0>[2] sigma;
  
  // Subject-lresponseel raw parameters (for Matt trick)
  real A_pr;    // learning rate
  real k_pr;    // learning rate

  // vector[N] tau_pr;  // inverse temperature
  // real<lower=0> gamma;
}

//transformed parameters {
  // subject-lresponseel parameters
  // vector<lower=0,upper=1>[N] A;
  // vector<lower=0,upper=5>[N] tau;
  
  // for (i in 1:N) {
  //   A[i]   = Phi_approx( mu_p[1]  + sigma[1]  * A_pr[i] );
  //  tau[i] = Phi_approx( mu_p[2] + sigma[2] * tau_pr[i] ) * 5;
  // }
//}

model{
A_pr   ~ normal(0,1);
k_pr ~ normal(0,1);

for (i in 1:1) {
    vector[2] EV; // expected value
    real PE;      // prediction error
    
    EV = initV;
  for (t in 1:80) {        
    // compute action probabilities
   response[t] ~ normal( EV[stimulus[t]] * k_pr,1);
      
    // prediction error 
    PE = shock[t] - EV[stimulus[t]];
      
    // value updating (learning) 
   EV[stimulus[t]] = EV[stimulus[t]] + A_pr * PE; 
  
   }
   }
}


