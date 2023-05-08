library(ggplot2)
library(viridis)
library(scales)
library(RColorBrewer)
library(rlang)
library(ggpubr)
library(plyr)

OurConodontData = read.csv("../Data sets/Our raman data.csv")
Specdata = read.csv("../Data sets/Sample spectra all.csv")
OtherAuthorConoData = read.csv("../Data sets/All conodont raman data.csv")
ThomasTeethData = read.csv("../Data sets/Thomas Teeth vs Conos.csv")


#### Chapter 1 : plots of our data ####

## Plots our Raman data for all 6 conodonts
p = ggplot(Specdata,aes(x=Prox)) + 
  geom_line(aes(y = Proy), color = "#aecec5ff",linewidth =0.75,) +
  geom_line(aes(y = Pany), color = "#cad5c1ff", linewidth =0.75,) +
  geom_line(aes(y = Excay), color = "#bf9e66ff",linewidth =0.75,) +
  geom_line(aes(y = Bispy), color = "#a36b2bff",linewidth =0.75,) +
  geom_line(aes(y = Paly), color = "#dcd1a2ff",linewidth =0.75,) +
  geom_line(aes(y = Tripy), color = "#2686a0ff",linewidth =0.75,) +
  xlim(940,980)+
  ylim(6500,14000)+
  xlab(expression("Wavenumber (cm"^-1*")")) + 
  ylab("Relative Intensity (arbitrary units)")+
  theme_classic()+
  theme(axis.text.y = element_text(angle = 90))

## Plots our Raman data for all 6 conodonts
p1 = ggplot(OurConodontData, aes(y=FWHM, x=Peak,color=Sample.name, shape=Sample.name)) + 
  geom_point(size=3,stroke = 2) + 
  scale_shape_manual(values=c(4,15,16,17,18,25))+
  ylab(expression("FWHM of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) + 
  xlab(expression("PCMI of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme_classic()+
  scale_colour_manual(values=hcl.colors(n=6, palette = "Earth"))

## Plots our Raman data for all 6 conodonts (Color is CAI)
p2 = ggplot(OurConodontData, aes(y=FWHM, x=Peak,color=CAI,shape=Sample.name)) + 
  geom_point(size=3,stroke = 2) + 
  scale_shape_manual(values=c(4,15,16,17,18,25)) + 
  ylab(expression("FWHM of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+ 
  xlab(expression("PCMI of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme_classic()+
  scale_colour_gradient(low = "#dcb37b", high = "#5e4a4b")

## Plots our Raman data for all 6 conodonts (Color is inside to outside)
p3 = ggplot(OurConodontData, aes(y=FWHM, x=Peak,color=Line,shape=Sample.name)) + 
  geom_point(size=3,stroke = 2) + 
  scale_shape_manual(values=c(4,15,16,17,18,25))+ 
  ylab(expression("FWHM of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) + 
  xlab(expression("PCMI of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  scale_colour_gradient(low = "#b6d7a8", high = "#3a4b48")+
  theme_classic()

## Combined plot of all our conodont data
ggarrange(p,p1, p2, p3,
              labels = c("A", "B", "C","D"),
              ncol = 2, nrow = 2)

#### Chapter 2: Plots of our data vs that of other authors####

## Plot our data vs other publications with conodont raman data

pa = ggplot(OtherAuthorConoData, aes(y=FWHM, x=Peak, color=Author)) + 
  geom_point(size=3) +
  theme_classic()+
  ylab(expression("FWHM of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) +
  xlab(expression("PCMI of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme(legend.key.size = unit(0.4, 'cm')) +
  scale_color_manual(values=c("#f1873a", "#0d455f","#fcd804", "#31b6b2"))+
  xlim(954,968)+
  ylim(0,20)+
  theme(axis.text.x=element_blank(),
          axis.ticks.x=element_blank())+
  stat_ellipse()

## Plot our data vs Thomas et.al. 2011 data (selected for enamel,enameloid and dentine)

pb = ggplot(ThomasTeethData, aes(y=FWHM, x=Peak, color=Name, shape=Location
 )) + 
  geom_point(size=3) +
  scale_shape_manual(values=c(1:26))+
  theme_classic()+
  theme(legend.key.size = unit(0.4, 'cm')) +
  geom_point(size=5) + 
  scale_shape_manual(values=c(16,15,17,18))+
  ylab(expression("FWHM of v"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) + 
  xlab(expression("PCMI of v"[1]*"-(PO"[4]*") peak (cm"^-1*")")) +
  scale_color_manual(values=c('#EBDA69', '#fcd804', 'darkgray', '#61288A', '#7D33B2', '#AE74D7', '#C59CE2', '#DCC3EE', 
                                '#C8DDDC',  '#4C9338', '#5FB846', '#7EC76A',
                                              "#9ED58F"))+
  theme(legend.key.size = unit(0.4, 'cm')) +
  xlim(954,968)+
  ylim(0,20)
  
  
ggarrange(pa, pb,
          labels = c("A", "B", "C","D"),
          ncol = 1, nrow = 2)

