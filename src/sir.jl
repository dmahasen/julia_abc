using Base: Int64
### implementation of SIR model

function sir(initState,param,obsTimes)
    (S , I , R) = initState
    (β, α) = param

    N = S + I + R # population size 

    numObs = length(obsTimes)

    resS = zeros(Int64,numObs)
    resI = zeros(Int64,numObs)
    resR = zeros(Int64,numObs)

    tCurr  = 0
    obsCounter = 1  # to keep track off number of observations 
  
    
    infT = I # number of infectives at time t
    susT = N - infT  # number of susceptible at time t
    recT = R  # number of susceptible at time t  , when t=0, recT = 0
   
    k  = 1

    # Start - Main iteration 
    while infT > 0 

        t_rate  = β*susT*infT/N + α*infT  # infectious time of each individual is independent from other
        
         
        #time of the next event  - (infection or recovery)
        # print(t_rate)
      
        nextT  = (-1/t_rate)*log(rand()) #rexp(1,t_rate)
    
        tCurr = tCurr + nextT
      
        ##########################################################################
         # Update observations 

         while obsCounter <= numObs && tCurr > obsTimes[obsCounter]
            resI[obsCounter] = infT
            resR[obsCounter] = recT
            resS[obsCounter] = susT
                            
            obsCounter = obsCounter + 1
         end

         # Process will not be observed further
        if tCurr > obsTimes[numObs]
            return [resS resI resR]
        end

        ##########################################################################    
      
      
        u  = rand() 
      
        ################### Event 1 :- Infection #################################
        if u  < (β*susT*infT/N)/t_rate 
            susT = susT - 1
            infT = infT + 1
        else
        #################### Event 2 :- Recovery #################################
            recT  =  recT + 1
            infT  =  infT - 1
        end

        k  = k +1

    end # END - Main Iteration 
      
    #Process stops , no more infections, no more recovery 
    if infT == 0 
        for i in obsCounter:numObs
            resI[i] =  0;
            resR[i] = recT;
            resS[i] = susT;
        end

        return [resS resI resR]
    end
       

     
    
end