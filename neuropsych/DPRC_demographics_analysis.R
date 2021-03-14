#Analysing demographics information from the DPRC cohort. Here, we will be looking at the age and sex of the participants 
#and the clinical sites (Auckland, Christchurch and Dunedin) of where the participant MRI scans took place. We have 5 
#participant groups of interest, which are: Controls (C), subjective cognitive decline (SCD), amnestic mild cognitive 
#impairment (aMCI), multiple-domain mild cognitive impairment (mMCI), and Alzheimer's disease (AD).   


#Author: Lenore Tahara-Eckl
#Email: Ltah262@aucklanduni.ac.nz
#Date: 1/12/20


#load libraries via pacman
pacman::p_load(dplyr, ggplot2, psych, car)

#read in excel files (participant file)
DPRC_demographics <- read.csv("DPRC_subject_list_(Lenore).csv")
covariates_data <- read.csv("covariates-participants-lined-up.csv")

#rename some columns
names(DPRC_demographics)[5] <- "Age"
names(DPRC_demographics)[6] <- "Sex"
names(DPRC_demographics)[7] <- "Sex_binary"
names(DPRC_demographics)[9] <- "Classification"
names(DPRC_demographics)[10] <- "ACE_score"



#remove 0s (excluded) and -1s (not yet classified) from the data (classifications of participants).
DPRC_demographics_classification <- replace(DPRC_demographics$Classification, DPRC_demographics$Classification<=0, NA)
DPRC_demographics$Classification <- DPRC_demographics_classification


#convert categorical variables to a factor
DPRC_demographics$Classification <- as.factor(DPRC_demographics$Classification)
covariates_data$Group <- as.factor(covariates_data$Group)

#convert continuous variables to a numeric
DPRC_demographics$Age <- as.numeric(as.character(DPRC_demographics$Age))


#look at descriptive statistics
age_descrip <- describeBy(DPRC_demographics$Age, DPRC_demographics$Classification)
ACE_descrip <- describeBy(DPRC_demographics$ACE_score, DPRC_demographics$Classification)



#plot the data to visualise



#plot age
ggplot(subset(DPRC_demographics, Classification %in% c("1", "2", "3", "4", "5")), aes(x = Classification, y = Age)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Classification)) + 
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Classification)) + 
    ylim(50, 95) +
    xlab("Group_status") + 
    ylab("Age") +
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) + 
    theme_classic() +
    theme(legend.position = "none")

#plot gender
gender_data <- data.frame(table(covariates_data$Classification, covariates_data$Sex))
names(gender_data) <- c("Group", "Sex", "Count")
Group_order <- c("C", "SCD", "aMCI", "mMCI", "AD")
gender_data <- gender_data %>% arrange(factor(Group, levels=Group_order))
gender_data$Group <- factor(gender_data$Group, levels=c("C", "SCD", "aMCI", "mMCI", "AD"))

ggplot(data=gender_data, aes(x=Group, y=Count, fill=Sex)) +
    geom_bar(stat="identity")


#plot clinical site
location_data <- data.frame(table(covariates_data$Classification, covariates_data$Clinical_site))
names(location_data) <- c("Group", "Clinical_site", "Count")
location_data <- location_data %>% arrange(factor(Group, levels=Group_order))
location_data$Group <- factor(location_data$Group, levels=c("C", "SCD", "aMCI", "mMCI", "AD"))

ggplot(data=location_data, aes(x=Group, y=Count, fill=Clinical_site)) +
    geom_bar(stat="identity")


#plot ACE
ggplot(subset(DPRC_demographics, Classification %in% c("1", "2", "3", "4", "5")), aes(x = Classification, y = ACE_score)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Classification)) + 
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Classification)) + 
    xlab("Group_status") + 
    ylab("ACE_score") +
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) + 
    theme_classic() +
    theme(legend.position = "none")



#plot FBA metrics--
#for FD:
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Group, y = Mean_FD)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Group)) + 
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Group)) + 
    xlab("Group_status") + 
    ylab("FD") +
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) + 
    theme_classic() +
    theme(legend.position = "none")
#for FC:
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Group, y = Mean_FC)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Group)) + 
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Group)) + 
    xlab("Group_status") + 
    ylab("FC") +
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) + 
    theme_classic() +
    theme(legend.position = "none")
#for FDC:
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Group, y = Mean_FDC)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Group)) + 
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Group)) + 
    xlab("Group_status") + 
    ylab("FDC") +
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) + 
    theme_classic() +
    theme(legend.position = "none")



#check for significant difference in age between groups 
age_mod <- lm(Age ~ Classification, data = DPRC_demographics)
anova(age_mod)


#check for significant difference in gender between groups 
#reformat data for chi-square test
gender_data_chisq <- rbind(c(20,30,14,17,5), c(4,23,22,12,10))
colnames(gender_data_chisq) <- c("C", "SCD", "aMCI", "mMCI", "AD")
rownames(gender_data_chisq) <- c("F", "M")
#run chi-square test
gender_chi_test <- chisq.test(gender_data_chisq)


#check for significant difference in clinical site between groups 
#reformat data for chi-square test
location_data_chisq <- rbind(c(22,39,25,24,13), c(2,5,6,4,1), c(0,9,5,1,1))
colnames(location_data_chisq) <- c("C", "SCD", "aMCI", "mMCI", "AD")
rownames(location_data_chisq) <- c("Auckland", "Christchurch", "Dunedin")
#run chi-square test
location_chi_test <- chisq.test(location_data_chisq)
#if expected values in cells are too small, simulate more p-values:
#location_chi_test <- chisq.test(location_data_chisq, simulate.p.value = TRUE)


#check for significant difference in ACE between groups 
ACE_mod <- lm(ACE_score ~ Classification, data = DPRC_demographics)
anova(ACE_mod)




#check for significant difference in FBA metrics between groups 
FD_mod <- lm(Mean_FD ~ Group, data = covariates_data)
anova(FD_mod)
FC_mod <- lm(Mean_FC ~ Group, data = covariates_data)
anova(FC_mod)
FDC_mod <- lm(Mean_FDC ~ Group, data = covariates_data)
anova(FDC_mod)



#quick view of the data
plot(age_mod)


#Perform Levene's Test for homogenity of variances
leveneTest(Age ~ Classification, data = DPRC_demographics)


leveneTest(Mean_FD ~ Group, data = covariates_data)
leveneTest(Mean_FD ~ Sex, data = covariates_data)





#Perform a Shapiro-Wilk test for normality of residuals
shapiro.test(age_mod$residuals)


#check to see if variables have a linear relationship (e.g. age vs. white matter integrity metrics)
#for Mean FD
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Age, y = Mean_FD, shape = Group, color = Group)) +
    geom_point() +
    geom_smooth(method="lm", formula= y~x, se=FALSE) +
    ggtitle("Age vs. fibre density (FD)") +
    theme(plot.title = element_text(hjust=0.5))
    #scale_x_discrete(labels = c("1"="Control", "2"="SCD", "3"="aMCI", "4"="mMCI", "5"="AD")) 
    

#for Mean FC
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Age, y = Mean_FC, shape = Group, color = Group)) +
    geom_point() +
    geom_smooth(method="lm", formula= y~x, se=FALSE) +
    ggtitle("Age vs. fibre cross-section (FC)") +
    theme(plot.title = element_text(hjust=0.5))


#for Mean FDC
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Age, y = Mean_FDC, shape = Group, color = Group)) +
    geom_point() +
    geom_smooth(method="lm", formula= y~x, se=FALSE) +
    ggtitle("Age vs. fibre density & cross-section (FDC)") +
    theme(plot.title = element_text(hjust=0.5))




#all 3 metrics (FD, FC, FDC)
ggplot(subset(covariates_data, Group %in% c("1", "2", "3", "4", "5")), aes(x = Age)) +
    geom_point(aes(y=Mean_FD, color="Mean_FD")) + 
    geom_smooth(aes(y=Mean_FD, color="Mean_FD"), method="lm", formula= y~x, se=FALSE) +
    geom_point(aes(y=Mean_FC, color="Mean_FC")) + 
    geom_smooth(aes(y=Mean_FC, color="Mean_FC"), method="lm", formula= y~x, se=FALSE) +
    geom_point(aes(y=Mean_FDC, color="Mean_FDC")) + 
    geom_smooth(aes(y=Mean_FDC, color="Mean_FDC"), method="lm", formula= y~x, se=FALSE) +
    ylab("FBA metrics") +
    ggtitle("Age vs. all 3 metrics (FD, FC, & FDC)") +
    theme(plot.title = element_text(hjust=0.5))



plot(covariates_data$Age, covariates_data$Mean_FD)



#check for significance with age and between age x group and white matter integrity (FBA metrics)
#run correlation + simple linear regression between age and white matter metrics
#for FD
Age_FBA_FD_cor <- cor.test(covariates_data$Age, covariates_data$Mean_FD)
Age_FBA_FD_mod <- lm(Mean_FD ~ Age, data = covariates_data)
summary(Age_FBA_FD_mod)
anova(Age_FBA_FD_mod)
#for FC
Age_FBA_FC_cor <- cor.test(covariates_data$Age, covariates_data$Mean_FC)
Age_FBA_FC_mod <- lm(Mean_FC ~ Age, data = covariates_data)
summary(Age_FBA_FC_mod)
#for FDC
Age_FBA_FDC_cor <- cor.test(covariates_data$Age, covariates_data$Mean_FDC)
Age_FBA_FDC_mod <- lm(Mean_FDC ~ Age, data = covariates_data)
summary(Age_FBA_FDC_mod)

#run multiple linear regression on age x group and white matter integrity (FBA metrics)
#for FD
AgexGroup_FD_mult_mod <- lm(Mean_FD ~ Age + Group + Age:Group, data = covariates_data)
summary(AgexGroup_FD_mult_mod)
anova(AgexGroup_FD_mult_mod)
#for FC
AgexGroup_FC_mult_mod <- lm(Mean_FC ~ Age + Group + Age:Group, data = covariates_data)
summary(AgexGroup_FC_mult_mod)
anova(AgexGroup_FC_mult_mod)
#for FDC
AgexGroup_FDC_mult_mod <- lm(Mean_FDC ~ Age + Group + Age:Group, data = covariates_data)
summary(AgexGroup_FDC_mult_mod)
anova(AgexGroup_FDC_mult_mod)



Sex_Group_FD_mod <- lm(Mean_FD ~ Group + Sex + Group:Sex, data = covariates_data)



#plot gender against white matter integrity metrics (FBA)
#for FD
ggplot(covariates_data, aes(x = Sex, y = Mean_FD)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Sex)) +
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Sex)) +
    xlab("Sex") + 
    ylab("Mean_FD")
#for FC
ggplot(covariates_data, aes(x = Sex, y = Mean_FC)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Sex)) +
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Sex)) +
    xlab("Sex") + 
    ylab("Mean_FC")
#for FDC
ggplot(covariates_data, aes(x = Sex, y = Mean_FDC)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Sex)) +
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Sex)) +
    xlab("Sex") + 
    ylab("Mean_FDC")
     
    
#check if there's a difference between the white matter integrity metrics (FBA) between gender
#for FD
t.test(covariates_data$Mean_FD ~ covariates_data$Sex, var.equal = TRUE)
#for FC
t.test(covariates_data$Mean_FC ~ covariates_data$Sex, var.equal = TRUE)
#for FDC
t.test(covariates_data$Mean_FDC ~ covariates_data$Sex, var.equal = TRUE)



#plot group status and gender against white matter integrity metrics (FBA) - 2x5 factorial ANOVA
#for FD
ggplot(covariates_data, aes(x = Group, y = Mean_FD, color = Sex)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Sex)) +
    stat_summary(fun = mean, geom = "point", position = position_dodge(.5), shape = 19, size = 2, aes(colour = Sex)) +
    xlab("Group_status") + 
    ylab("Mean_FD")+
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) 
#for FC
ggplot(covariates_data, aes(x = Group, y = Mean_FC, color = Sex)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Sex)) +
    stat_summary(fun = mean, geom = "point", position = position_dodge(.5), shape = 19, size = 2, aes(colour = Sex)) +
    xlab("Group_status") + 
    ylab("Mean_FC")+
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) 
#for FDC
ggplot(covariates_data, aes(x = Group, y = Mean_FDC, color = Sex)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Sex)) +
    stat_summary(fun = mean, geom = "point", position = position_dodge(.5), shape = 19, size = 2, aes(colour = Sex)) +
    xlab("Group_status") + 
    ylab("Mean_FDC")+
    scale_x_discrete(labels = c("1" = "Control", "2" = "SCD", "3" = "aMCI", "4" = "mMCI", "5" = "AD")) 



#check for significant difference in white matter integrity between groups, gender, and groups x gender
# 2x5 factorial ANOVA
#for FD
Sex_Group_FD_mod <- lm(Mean_FD ~ Group + Sex + Group:Sex, data = covariates_data)
anova(Sex_Group_FD_mod)
#for FC
Sex_Group_FC_mod <- lm(Mean_FC ~ Group + Sex + Group:Sex, data = covariates_data)
anova(Sex_Group_FC_mod)
#for FDC
Sex_Group_FDC_mod <- lm(Mean_FDC ~ Group + Sex + Group:Sex, data = covariates_data)
anova(Sex_Group_FDC_mod)





#plot clinical site against white matter integrity metrics (FBA)
#for FD
ggplot(covariates_data, aes(x = Clinical_site, y = Mean_FD)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Clinical_site)) +
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Clinical_site)) +
    xlab("Clinical_site") + 
    ylab("Mean_FD")
#for FC
ggplot(covariates_data, aes(x = Clinical_site, y = Mean_FC)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Clinical_site)) +
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Clinical_site)) +
    xlab("Clinical_site") + 
    ylab("Mean_FC")
#for FDC
ggplot(covariates_data, aes(x = Clinical_site, y = Mean_FDC)) + 
    geom_boxplot(width = 0.5, fill = "white", outlier.size = 1, aes(colour = Clinical_site)) +
    stat_summary(fun = mean, geom = "point", shape = 19, size = 2, aes(colour = Clinical_site)) +
    xlab("Clinical_site") + 
    ylab("Mean_FDC")


#check for significant difference in white matter integrity between clinical sites
#for FD
Clinical_site_FD_mod <- lm(Mean_FD ~ Clinical_site, data = covariates_data)
anova(Clinical_site_FD_mod)
#for FC
Clinical_site_FC_mod <- lm(Mean_FC ~ Clinical_site, data = covariates_data)
anova(Clinical_site_FC_mod)
#for FDC
Clinical_site_FDC_mod <- lm(Mean_FDC ~ Clinical_site, data = covariates_data)
anova(Clinical_site_FDC_mod)













