install.packages(c("xlsx", "mosaic", "car", "phia"))
# CALCULATOR (USE IN CONSOLE) ----
2 + 2                  
7 - 8
4 * 6
144 / 12
8 ^ 9
2 + 2 * (2 ^ 6)

# UP KEY ----

# SCRIPT ----
8 * 6

# CREATING OBJECTS ----
a <- 10 * 6
a

A <- 2 + 6 # CASE SENSISTIVE
A
a

# OVERWRITING OBJECTS ----
a <- 0
a

# NAMING OBJECTS ----
1object <- 3
!object <- 3
-object <- 3
object1 <- 3
object! <- 3
my.object <- 3
my_object <- 3
myObject <- 3

#REMOVING OBJECTS ----
rm(A)

# DATA CLASSES ----
12.6    # NUMERIC
"Male"  # CHARACTER
TRUE    # LOGICAL

# DATA STRUCTURES ----
# VECTOR
c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
c(1:10)
c("Mon", "Tue", "Wed", "Thur", "Fri")
c(Mon, Tue, Wed, Thur, Fri)           # CHARACTER STRINGS MUST BE IN QUOTES
c(FALSE, TRUE, TRUE, FALSE, FALSE)
c(false, true)                        # LOGICAL MUST BE IN CAPITALS
myVector <- c(F, F, F, T, T)          # BUT CAN BE ABBREVIATED
myVector
numbers <- c(1:10)
numbers * 2                           # OPERATIONS CAN BE PERFORMED ON VECTORS
numbers + 3
numbers + numbers

# LIST
list(1, 2, 3, "hello", FALSE)
list(myVector, 1, 2, 3, "hello", FALSE) # LISTS CAN CONTAIN LISTS AND VECTORS
list(myVector, c(1, 2, 3), "hello", FALSE)

# DATA.FRAME (COME BACK TO)
# MENTION MATRICES AND ARRAYS BRIEFLY

# SUBSETTING VECTORS ----
days <- c("Mon", "Tue", "Wed", "Thur", "Fri")
days
days[1]
days[4]
days[c(1, 3, 4)]
days[1:4]
days[-5]

# FUNCTIONS ----
myValues <- c(1:100)
myValues
mean(myValues)
median(myValues)
min(myValues)
max(myValues)
sum(myValues)
sd(myValues)
class(myValues)
length(myValues) # SOME FUNCTIONS RETURN SINGLE VALUES (AGGREGATE FUNCTIONS)
log(myValues)    # OTHERS RETURN A VALUE FOR EACH COMPONENT OF THE VECTOR
log10(myValues)  # CAREFUL: DIFFERENCE BETWEEN LOG10 AND LOG
mySqrt <- sqrt(myValues)
mySqrt
?rnorm           # HELP ON HOW TO USE A FUNCTION
rnorm(100, mean = 5)
hist(rnorm(100, mean = 5))

# DATA.FRAMES ----
id <- (1:200)
group <- c(rep("Vehicle", 100), rep("Drug", 100))
response <- c(rnorm(100, mean = 25, sd = 5), rnorm(100, mean = 23, sd = 5))
myData <- data.frame(Patient = id, Treatment = group, Response = response)
myData # CTRL+L
head(myData) # REMIND DATA WILL BE DIFFERENT BECAUSE OF RANDOM SEED
head(myData, 12)
tail(myData, 10)
dim(myData)
str(myData)
summary(myData)

# SUBSETTING DATA.FRAMES ----
myData[1, 2] #[ROWS, COLUMNS]
myData[2, 3]
myData[1:20, 2:3]
myData[1:20, ]
myData[, 3]
myData[, "Response"]
myData$Response
myData[myData$Response > 26, ]
myData[myData$Treatment == "Vehicle" & myData$Response <= 23, ]
myData[myData$Treatment == "Vehicle" | myData$Response >= 21, ]
myData[myData$Treatment != "Vehicle" | myData$Response > 24, ]
age <- round(rnorm(200, mean = 40, sd = 20))
myData$Age <- age
head(myData)
  
# READING DATA INTO R ----
pokemon <- read.csv("Pokemon.csv", header = T) # EXPLAIN HEADER (DEFAULT IS TRUE)
dim(pokemon)
head(pokemon)
str(pokemon)
summary(pokemon)

library(xlsx)
pokemon <- read.xlsx("Pokemon.xlsx", sheetIndex = 1) # EXPLAIN HEADER (DEFAULT IS TRUE)
dim(pokemon)
head(pokemon)
str(pokemon)
summary(pokemon) 

# PLOT DATA ---
plot(pokemon)
plot(pokemon[, 3:10])
plot(pokemon[, "Type.I"], pokemon[, "Atk"], ylab = "Attack")

# T TESTS AND WILCOX TESTS----
psychic <- pokemon[pokemon$Type.I == "Psychic", "Atk"]
rock <- pokemon[pokemon$Type.I == "Rock", "Atk"]
t.test(psychic, rock)
#bartlett.test(c(psychic, rock), c(rep("Psy", length(psychic)), rep("rock", length(rock)))) # TOO COMPLICATED, ONLY COVER IF ASKED
t.test(psychic, rock, var.equal = TRUE)
t.test(psychic, rock, var.equal = TRUE, alternative = "greater")
t.test(psychic, rock, paired = TRUE) # WONT WORK
t.test(psychic[1:13], rock, paired = TRUE)
wilcox.test(psychic, rock)
wilcox.test(psychic[1:13], rock, paired = TRUE)

# LINEAR REGRESSION ----
plot(pokemon$Atk, pokemon$Def)
regModel <- lm(Def ~ Atk, data = pokemon)
regModel
abline(regModel$coef[1], regModel$coef[2], col = "red", lwd = 3)
summary(regModel)
hist(regModel$res)
qqnorm(regModel$res)
qqline(regModel$res)

regModelLog <- lm(log10(Def) ~ Atk, data = pokemon)
regModelLog
plot(pokemon$Atk, log10(pokemon$Def))
abline(regModelLog$coef[1], regModelLog$coef[2], col = "red", lwd = 3)
summary(regModelLog)
hist(regModelLog$res, breaks = 40)
qqnorm(regModelLog$res)
qqline(regModelLog$res)

# ANOVA AND KRUSKAL-WALLIS ----
pokeSubset <- pokemon[pokemon$Type.I == "Ghost" | pokemon$Type.I == "Grass" | pokemon$Type.I == "Ground" | pokemon$Type.I == "Ice", ]

pokeSubset$Type.I <- factor(pokeSubset$Type.I)
plot(pokeSubset[, "Type.I"], pokeSubset[, "Atk"], ylab = "Attack")

oneWayModel <- lm(Atk ~ Type.I, data = pokeSubset)
oneWayModel
mean(pokeSubset[pokeSubset$Type.I == "Ghost", "Atk"])
mean(pokeSubset[pokeSubset$Type.I == "Grass", "Atk"]) - mean(pokeSubset[pokeSubset$Type.I == "Ghost", "Atk"]) 
summary(oneWayModel)
anova(oneWayModel)
hist(oneWayModel$res)
qqnorm(oneWayModel$res)
qqline(oneWayModel$res)
bartlett.test(pokeSubset$Atk, pokeSubset$Type.I)
oneway.test(Atk ~ Type.I, data = pokeSubset)
oneway.test(Atk ~ Type.I, data = pokeSubset, var.equal = T)

kruskal.test(pokeSubset$Atk, pokeSubset$Type.I)

library(mosaic)
TukeyHSD(oneWayModel)
pairwise.t.test(pokeSubset$Atk, pokeSubset$Type.I)
pairwise.t.test(pokeSubset$Atk, pokeSubset$Type.I, p.adjust.method = "bonferroni")
pairwise.t.test(pokeSubset$Atk, pokeSubset$Type.I, p.adjust.method = "none")
p.adjust(c(0.316, 0.069), method = "holm")

pairwise.wilcox.test(pokeSubset$Atk, pokeSubset$Type.I)
pairwise.wilcox.test(pokeSubset$Atk, pokeSubset$Type.I, p.adjust.method = "none")

# TWO-WAY ANOVA ---- 
pokeSubset2 <- pokemon[pokemon$Type.I == "Bug" |
                       pokemon$Type.I == "Electric" |
                       pokemon$Type.I == "Fire" | 
                       pokemon$Type.I == "Poison", ]

pokeSubset2$Type.I <- factor(pokeSubset2$Type.I)
boxplot(Atk ~ Captive * Type.I, data = pokeSubset2, col = c("red", "blue"), ylab = "Attack")

twoWayModel <- lm(Atk ~ Type.I * Captive, data = pokeSubset2)
twoWayModel
summary(twoWayModel)
anova(twoWayModel)

twoWayModelRev <- lm(Atk ~ Captive * Type.I, data = pokeSubset2)
anova(twoWayModelRev)

# TYPE III SS ----
library(car)
twoWayModel <- lm(Atk ~ Type.I * Captive, data = pokeSubset2, contrasts = list(Type.I = contr.sum, Captive = contr.sum))
twoWayModelRev <- lm(Atk ~ Captive * Type.I, data = pokeSubset2, contrasts = list(Type.I = contr.sum, Captive = contr.sum))
Anova(twoWayModel, type = 3)
Anova(twoWayModelRev, type = 3)

# POST-HOC TESTS ----
TukeyHSD(twoWayModel, "Type.I") # ONLY APPROPRIATE FOR ONE-WAY POST-HOC
library(phia)
testInteractions(twoWayModel, pairwise = "Captive", fixed = "Type.I")
testInteractions(twoWayModel, pairwise = "Type.I", fixed = "Captive", adjustment = "none")
