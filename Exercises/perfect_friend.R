#Perfect Best Friend Setup
y0 <- c(10, 15, 10, 8, 6, 15, 5, 13, 15, 11, 10, 15)
y1 <- c(10, 15, 12, 11, 9, 11, 7, 11, 6, 9, 13, 15)

# Assume perfect assignment, where ties given d=0
d <- ifelse(y1 > y0, 1, 0) 
y <- ifelse(d == 1, y1, y0)
ate <- function(y1, y0) mean(y1 - y0)
att <- function(y1, y0, d) mean((y1 - y0)[d==1])
atu <- function(y1, y0, d) mean((y1 - y0)[d==0])
sdo <- function(y, d) mean(y[d==1]) - mean(y[d==0])
pi <- function(d) mean(d) 
                        
SDO <- ate(y1, y0) + 
    # Selection bias
    mean(y0[d==1]) - mean(y0[d==0]) + 
    # Heterogeneous treatment effect bias
    (1 - pi(d))*(att(y1, y0, d) - atu(y1, y0, d)) 
# Verify equality of decomposition
all.equal(SDO, sdo(y, d))

cat(att(y1, y0, d)) 
cat(atu(y1, y0, d)) 
