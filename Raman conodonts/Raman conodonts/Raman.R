library(ggplot2)
library(scales)
library(rlang)
library(ggpubr)
library(plyr)
library(lmodel2)

OurConodontData = read.csv("../Data sets/Our raman data.csv")
Specdata = read.csv("../Data sets/Sample spectra all.csv")
OtherAuthorConoData = read.csv("../Data sets/All conodont raman data.csv")
ThomasTeethData = read.csv("../Data sets/Thomas Teeth vs Conos.csv")


#### Chapter 1 : plots of our data ####

## Plots our Raman data for all 6 conodonts
p = ggplot2::ggplot(Specdata,aes(x=Spectra)) + 
  geom_line(aes(y = Pro..muelleri), color = "#aecec5ff",linewidth =0.75,) +
  geom_line(aes(y = Pan..equicostatus), color = "#cad5c1ff", linewidth =0.75,) +
  geom_line(aes(y = W..excavata), color = "#bf9e66ff",linewidth =0.75,) +
  geom_line(aes(y = B..cf..aculeatus), color = "#a36b2bff",linewidth =0.75,) +
  geom_line(aes(y = Palmatolepis.sp.), color = "#dcd1a2ff",linewidth =0.75,) +
  geom_line(aes(y = T..gracilis), color = "#2686a0ff",linewidth =0.75,) +
  xlim(940,980)+
  ylim(6500,14000)+
  xlab(expression("Wavenumber (cm"^-1*")")) + 
  ylab("Relative Intensity (arbitrary units)")+
  theme_classic()+
  theme(axis.text.y = element_text(angle = 90))

## Plots our Raman data for all 6 conodonts
p1 = ggplot2::ggplot(OurConodontData, aes(y=FWHM, x=Peak,color=Sample.name, shape=Sample.name)) + 
  geom_point(size=3,stroke = 2) + 
  scale_shape_manual(values=c(4,15,16,17,18,25))+
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) + 
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme_classic()+
  scale_colour_manual(values=hcl.colors(n=6, palette = "Earth"))

## Plots our Raman data for all 6 conodonts (Color is CAI)
p2 = ggplot2::ggplot(OurConodontData, aes(y=FWHM, x=Peak,color=CAI,shape=Sample.name)) + 
  geom_point(size=3,stroke = 2) + 
  scale_shape_manual(values=c(4,15,16,17,18,25)) + 
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+ 
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme_classic()+
  scale_colour_gradient(low = "#dcb37b", high = "#5e4a4b")

## Plots our Raman data for all 6 conodonts (Color is inside to outside)
p3 = ggplot2::ggplot(OurConodontData, aes(y=FWHM, x=Peak,color=Line,shape=Sample.name)) + 
  geom_point(size=3,stroke = 2) + 
  scale_shape_manual(values=c(4,15,16,17,18,25))+ 
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) + 
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  scale_colour_gradient(low = "#b6d7a8", high = "#3a4b48")+
  theme_classic()

## Combined plot of all our conodont data
ggpubr::ggarrange(p,p1, p2, p3,
              labels = c("a", "b", "c","d"),
              ncol = 2, nrow = 2)

#### Chapter 2: Plots of our data vs that of other authors####

## Plot our data vs other publications with conodont raman data

pa = ggplot2::ggplot(OtherAuthorConoData, aes(y=FWHM, x=Peak, color=Author, shape=Author)) + 
  geom_point(size=3) +
  theme_classic()+
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) +
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme(legend.key.size = unit(0.4, 'cm')) +
  scale_shape_manual(values=c(16,15,17,18))+
  scale_color_manual(values=c("#8babf1", "#054fb9","#c44601", "#f57600"))+
  xlim(954,968)+
  ylim(0,20)

## Plot our data vs Thomas et.al. 2011 data (selected for enamel,enameloid and dentine)

pb = ggplot2::ggplot(ThomasTeethData, aes(y=FWHM, x=Peak, color=Name, shape=Location
 )) + 
  theme_classic()+
  geom_point(size=5) + 
  scale_shape_manual(values=c(16,15,17,18))+
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) + 
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]*") peak (cm"^-1*")")) +
  scale_color_manual(values=c('#EBDA69', '#fcd804', 'darkgray', '#61288A', '#7D33B2', '#AE74D7', '#C59CE2', '#DCC3EE', 
                                '#C8DDDC',  '#4C9338', '#5FB846', '#7EC76A',
                                              "#9ED58F"))+
  theme(legend.key.size = unit(0.4, 'cm')) +
  xlim(954,968)+
  ylim(0,20)
  
  
ggpubr::ggarrange(pa, pb,
          labels = c("A", "B", "C","D"),
          ncol = 1, nrow = 2)

#### Chapter 3: Regression analysis ####

models <- lapply(split(OtherAuthorConoData, OtherAuthorConoData$Author),
       lmodel2::lmodel2, formula=FWHM ~ Peak, range.y="relative", range.x="relative",
       nperm=99)

Zhang <- models$`Zhang et al. 2017`$regression.results[models$`Zhang et al. 2017`$regression.results$Method=="RMA",]
McMillan <- models$`McMillan & Golding 2019`$regression.results[models$`McMillan & Golding 2019`$regression.results$Method=="RMA",]
Rantitsch <- models$`Rantitsch et al. 2020`$regression.results[models$`Rantitsch et al. 2020`$regression.results$Method=="RMA",]
  
ggplot2::ggplot(OtherAuthorConoData, aes(y=FWHM, x=Peak, color=Author, shape=Author)) + 
  geom_point(size=3)+
  theme_classic()+
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) +
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme(legend.key.size = unit(0.4, 'cm')) +
  scale_shape_manual(values=c(16,15,17,18))+
  scale_color_manual(values=c("#8babf1", "#054fb9","#c44601", "#f57600"))+
  xlim(954,968)+
  ylim(0,20)+
  geom_abline(intercept = McMillan$Intercept, slope = McMillan$Slope, colour = "#8babf1")+
  geom_abline(intercept = Rantitsch$Intercept, slope = Rantitsch$Slope, colour = "#054fb9")

# Exporting slope coefficients and their confidence intervals into a file

CI_slope <- data.frame()
for (i in 1:length(models)) {
  CI_slope <- rbind(CI_slope, models[[i]]$confidence.intervals[4,4:5])
}

slope <- data.frame()
for (i in 1:length(models)) {
  slope <- rbind(slope, models[[i]]$regression.results[4,3])
}
colnames(slope) <- "Slope"

R_squared <- numeric()
for (i in 1:length(models)) {
  R_squared <- rbind(R_squared, models[[i]]$rsquare)
}

Slopes_RMA_CI <- cbind(slope, CI_slope, R_squared)
rownames(Slopes_RMA_CI) <- c("McMillan & Golding 2019","Rantitsch et al. 2020","Shirley et al. 2023","Zhang et al. 2017")


utils::write.table(Slopes_RMA_CI, 
            file = "Slopes_RMA_CI",
            sep = ",",
            col.names = TRUE)
            


