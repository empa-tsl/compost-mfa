setwd("~/Polybox/Projects/2018.10 Compost/Flows/20190530_Final_STAN_Jupyter/Concentration/")

SIM <- 100000

# load compost concentration data
load("~/Polybox/Projects/2018.10 Compost/Data/Schleiss/ConcentrationDistributions.Rdata")

## from
## Mandaliev, P.; Schleiss, K. Installations de Compostage et de Méthanisation
## Recensement En Suisse et Au Liechtenstein; 2016.
# 167 sites with 82093 t/a
# 131 sites with 290851 t/a
# 31 sites with 191666 t/a
# 39 sites with 691234 t/a

# create random vector with facility size (output produced in t/a)
facility.size <- sample(c(rep(492,167),
                          rep(2220,131),
                          rep(6183,31),
                          rep(17724,39)))*0.31

# total organic matter treated in Switzerland
total.OM <- sum(facility.size)

# concentration of plastic in processed organic waste
conc <- list("CompostAgriculture" = sample(Comp.Agri/100,
                                           length(facility.size),
                                           replace = T),
             "CompostHorticulture" = sample(Comp.Gard/100,
                                            length(facility.size),
                                            replace = T),
             "Digestate" = sample(Digestate/100,
                                  length(facility.size),
                                  replace = T))

# relative MP concentration
MP.conc <- sample(c(0.09, 0.02, 1.04, 0.16, 0.02, 0.10, 0.25)+1,SIM,replace = T)

Final.conc <- list()
for(k in 1:3){
  
  # create an empty matrix
  plast.mat <- matrix(0,SIM,length(facility.size))
  
  # calculate the total amount of plastic while randomizing the concentration in each facilty
  for(i in 1:SIM){
    plast.mat[i,] <- sample(conc[[k]])*facility.size
  }
  
  # calculate total plastic in Switzerland
  total.CH <- apply(plast.mat, 1, sum)
  
  # total concentration
  total.conc <- total.CH/total.OM #* MP.conc
  
  # save data
  write.csv(total.conc, file = paste0("TotalConcentration_",names(conc)[k],".csv"))
  Final.conc[[names(conc)[k]]] <- total.conc
  
  # plot
  hist(total.conc*100, main = names(conc)[k], xlab = "Concentration (kg/kg)")
}

{
  pdf(file = "ConcentrationVariability.pdf",
      width = 9,
      height = 3)
  par(mfrow = c(1,3))
  
  hist(Comp.Agri,
       main = "Variability of the plastic content\nin compost for agriculture",
       xlab = "Concentration (%)",
       col = "limegreen",
       freq = F)
  legend("topright",
         paste0(c("Mean", "SD", "Q75", "Q25"),
                " = ",
                round(c(mean(Comp.Agri),
                        sd(Comp.Agri),
                        quantile(Comp.Agri,probs = c(0.75, 0.25))), digits = 3),
                "%"),
         bty = "n")
  box()
  
  hist(Comp.Gard,
       main = "Variability of the plastic content\nin compost for gardening and horticulture",
       xlab = "Concentration (%)",
       col = "cornflowerblue",
       freq = F)
  legend("topright",
         paste0(c("Mean", "SD", "Q75", "Q25"),
                " = ",
                round(c(mean(Comp.Gard),
                        sd(Comp.Gard),
                        quantile(Comp.Gard,probs = c(0.75, 0.25))), digits = 3),
                "%"),
         bty = "n")
  box()
  
  hist(Digestate,
       main = "Variability of the plastic content\nin solid digestate",
       xlab = "Concentration (%)",
       col = "tomato",
       freq = F)
  legend("topright",
         paste0(c("Mean", "SD", "Q75", "Q25"),
                " = ",
                round(c(mean(Digestate),
                        sd(Digestate),
                        quantile(Digestate,probs = c(0.75, 0.25))), digits = 3),
                "%"),
         bty = "n")
  box()
  
  dev.off()
}

{
  pdf(file = "SwissConcentration.pdf",
      width = 9,
      height = 3)
  par(mfrow = c(1,3))
  
  hist(Final.conc[["CompostAgriculture"]]*100,
       main = "Swiss-wide plastic content in\ncompost for agriculture",
       xlab = "Concentration (%)",
       col = "limegreen",
       freq = F)
  legend("topright",
         paste0(c("Mean", "SD", "Q75", "Q25"),
                " = ",
                round(c(mean(Final.conc[["CompostAgriculture"]]*100),
                        sd(Final.conc[["CompostAgriculture"]]*100),
                        quantile(Final.conc[["CompostAgriculture"]]*100,probs = c(0.75, 0.25))), digits = 3),
                "%"),
         bty = "n")
  box()
  
  hist(Final.conc[["CompostHorticulture"]]*100,
       main = "Swiss-wide plastic content in\ncompost for gardening and horticulture",
       xlab = "Concentration (%)",
       col = "cornflowerblue",
       freq = F)
  legend("topright",
         paste0(c("Mean", "SD", "Q75", "Q25"),
                " = ",
                round(c(mean(Final.conc[["CompostHorticulture"]]*100),
                        sd(Final.conc[["CompostHorticulture"]]*100),
                        quantile(Final.conc[["CompostHorticulture"]]*100,probs = c(0.75, 0.25))), digits = 3),
                "%"),
         bty = "n")
  box()
  
  hist(Final.conc[["Digestate"]]*100,
       main = "Swiss-wide plastic content in\nsolid digestate",
       xlab = "Concentration (%)",
       col = "tomato",
       freq = F)
  legend("topright",
         paste0(c("Mean", "SD", "Q75", "Q25"),
                " = ",
                round(c(mean(Final.conc[["Digestate"]]*100),
                        sd(Final.conc[["Digestate"]]*100),
                        quantile(Final.conc[["Digestate"]]*100,probs = c(0.75, 0.25))), digits = 3),
                "%"),
         bty = "n")
  box()
  
  dev.off()
}
