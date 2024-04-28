install.packages(setdiff(c("ggplot2", "ggpubr", "lmodel2", "reticulate","osfr"), rownames(installed.packages())))  

library(ggplot2)
library(ggpubr)
library(lmodel2)
library(osfr)

#### Download data from OSF ####

source("get_data_from_osf.R")

get_data_from_osf(link = "https://osf.io/d7j69/")

OurConodontData = read.csv("Figure_5a.csv")
OurConodontData$Sample.name <- factor(OurConodontData$Sample.name,
                                      levels = c("Pro. muelleri", "Pan. equicostatus ", "B. cf. aculeatus", "W. excavata", "T. gracilis", "Palmatolepis sp."))
Specdata = read.csv("Figure_5b.csv")
OtherAuthorConoData = read.csv("Figure_6.csv")


#### Chapter 1 : plots of our data ####

## Plots our Raman data for all 6 conodonts
p = ggplot2::ggplot(Specdata,aes(x=Spectra)) + 
  geom_line(aes(y = Pro..muelleri), color = "#a36b2bff",linewidth =0.75,) +
  geom_line(aes(y = Pan..equicostatus), color = "#bf9e66ff", linewidth =0.75,) +
  geom_line(aes(y = W..excavata), color = "#2686a0ff",linewidth =0.75,) +
  geom_line(aes(y = B..cf..aculeatus), color = "#aecec5ff",linewidth =0.75,) +
  geom_line(aes(y = Palmatolepis.sp.), color = "#cad5c1ff",linewidth =0.75,) +
  geom_line(aes(y = T..gracilis), color = "#dcd1a2ff",linewidth =0.75,) +
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
  scale_colour_manual(values=c("#a36b2bff", # Pro.muelleri
                               "#bf9e66ff", # Pan.equicostatus
                               "#aecec5ff", # B. cf. aculeatus
                               "#2686a0ff", # W. excavata
                               "#dcd1a2ff", # T. gracilis
                               "#cad5c1ff") # Palmatolepis sp.
  )+theme(legend.position = "none")

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

Fig4 <- ggarrange(p, p1, 
                  ncol = 2, 
                  labels = c("a", "b"))

ggsave(filename = "Fig4.pdf",
       plot = Fig4,
       dpi = 300,
       width = 9,
       height = 4)

#### Chapter 2: Plots of our data vs that of other authors####

## Plot our data vs other publications with conodont raman data

ggplot2::ggplot(OtherAuthorConoData, aes(y=FWHM, x=Peak, color=Author, shape=Author)) + 
  geom_point(size=3) +
  theme_classic()+
  ylab(expression("FWHM of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) +
  xlab(expression("PCMI of ν"[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme(legend.key.size = unit(0.4, 'cm')) +
  scale_shape_manual(values=c(16,15,17,18))+
  scale_color_manual(values=c("#8babf1", "#054fb9","#c44601", "#f57600"))+
  xlim(954,968)+
  ylim(0,20)

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
  ylab(expression("FWHM of the "*nu[1]*"-(PO"[4]^-3*") peak (cm"^-1*")")) +
  xlab(expression("PCMI of the "*nu[1]*"-(PO"[4]^-3*") peak (cm"^-1*")"))+
  theme(legend.key.size = unit(0.6, 'cm')) +
  theme(legend.position = c(.82, .86), legend.text = element_text(size=12))+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold"))+
  scale_shape_manual(values=c(16,15,17,18))+
  scale_color_manual(values=c("#8babf1", "#054fb9","#c44601", "#f57600"))+
  xlim(954,968)+
  ylim(0,20)+
  geom_abline(intercept = McMillan$Intercept, slope = McMillan$Slope, colour = "#8babf1")+
  geom_abline(intercept = Rantitsch$Intercept, slope = Rantitsch$Slope, colour = "#054fb9")+
 theme(text = element_text(family = "Open Sans"))


ggplot2::ggsave(filename = "Raman_comparison_main_text.png",
                dpi = 300)

#### Exporting slope coefficients and their confidence intervals into a file ####

CI_slope <- data.frame()
for (i in 1:length(models)) {
  CI_slope <- rbind(CI_slope, models[[i]]$confidence.intervals[4,4:5])
}

slope <- data.frame()
for (i in 1:length(models)) {
  slope <- rbind(slope, models[[i]]$regression.results[4,3])
}
colnames(slope) <- "Slope"

R_squared <- data.frame()
for (i in 1:length(models)) {
  R_squared <- rbind(R_squared, models[[i]]$rsquare)
}
colnames(R_squared)<-"R_squared"



Slopes_RMA_CI <- cbind(slope, CI_slope, R_squared)

Slopes_RMA_CI <- sapply(Slopes_RMA_CI,
                        FUN = round,
                        digits = 2,
                        simplify = T)
Slopes_RMA_CI <- cbind(c("McMillan & Golding 2019","Rantitsch et al. 2020","Shirley et al. 2023","Zhang et al. 2017"),
                       Slopes_RMA_CI)
colnames(Slopes_RMA_CI) <- c("Study",colnames(CI_slope), "Slope", "R_squared")

Slopes_RMA_CI <- as.data.frame(Slopes_RMA_CI)

utils::write.table(Slopes_RMA_CI, 
            file = "Slopes_RMA_CI.csv",
            sep = ",",
            col.names = TRUE)
            


