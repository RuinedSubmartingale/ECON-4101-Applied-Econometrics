Lutz Kilian and Daniel P Murphy, "The Role of Oil Inventories and
Speculative Trading in the Global Market for Crude Oil", Journal of
Applied Econometrics, Vol. 29. No. 3, 2014, pp. 454-478.

The Matlab data files are zipped in the file km-matlab-data.zip. The
ASCII data files, which are in DOS format, are zipped in the file
km-ascii-data.zip. The Matlab program files are zipped in the file
km-programs.zip. Unix/Linux users should use "unzip -a" for
km-ascii-data.zip and km-programs.zip, but not for km-matlab-data.zip.


Data (1973.2-2009.8):

  kmData.txt/kmData.mat 

  the columns in kmData are, in the following order, percent change in
  global oil production, real activity index from Kilian(AER 2009), the
  log real price of oil, and changes in OECD crude oil inventories

worldprod.txt/worldprod.mat
  
  global world oil production (thousands of barrels per day)


Programs:

  Main.m 

  reads in kmData
  obtains reduced form coefficients (VARirf.m)
  rotates through identification matrix, saving admissible draws (IRFsign.m)
    note: Main.m uses seed 316 with 5 mllion rotations.
  imposes additional restrictions (supply elasticity, dynamic restrictions)  
    creates figures used in paper and table 2
    note: reads in the median elasticity in use, which is created and saved
          by BayesDraws.m
  
  Figure1.m
  
  reads in BayesPosterior.mat, which is created in BayesDraws.m
    note: Figure1.m, Figure2.m, and Figures3to7.m are called by Main.m and
    create the relevant tables. Each figure can be called independently
    once the admissible IRFs are obtained.
    	
  BayesDraws.m
  
  reads in kmData
  draws from posterior (BAYESsign.m)
  saves medelasuse.mat, which is called by Main.m
  saves BayesPosterior.mat (read by Figure1.m, which is called by Main.m)
    note: BayesDraws should be run before Main.m to create Figure 1. 
  computes quantiles of elasticities in use and production
	 

Instructions:

Run BayesDraws.m to generate the posterior IRFs and the median
elasticity in use, which will be used by Figure1.m. Note that it takes
a long time/substantial computing power to obtain a sufficient number
of draws.

Run Main.m to obtain the structural IRF based on the least-squared
estimate of the VAR.  Main.m will create the figures and tables used
in the paper.
