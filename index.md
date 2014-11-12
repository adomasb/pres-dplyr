How to solve 90 % of your data munging problems? Part I
========================================================
author: Adomas
date: 2014-11-14
autosize: true

Janitor work
========================================================

Data cleaning and munging consumes about 80% time of your analysis and your code is unreadable even for you! And while munging your data you look like this socialist janitor!

![alt text](data-janitor.jpg)

Maybe it is time to stop this?

========================================================
left: 70%
That is why we will learn how to do this insanely fast, beautifully and efficiently with `dplyr`. Give your janitor mopp to `dplyr`!

***

![alt text](janitor-meme.jpg)

Plan of workshop
========================================================

- Load data set for hands-on examples and tasks
- Familiarize with verbs
- Verbs: examples + tasks
- Pipe operator: examples + tasks
- Homework


Load packages
========================================================


```r
library(dplyr)
library(nycflights13)
```

If you do not have it already, then


```r
install.packages(c("dplyr", "nycflights13"))
```

Data set
=======================================================

We will used built-in data set of all flight that departed NYC in 2013.
Our data frame name -- ```flights```.

Dimensions of data frame:


```r
dim(flights)
```

```
[1] 336776     16
```

Take a look at first few lines of data frame with ```head()```


```r
head(flights)
```

dplyr verbs
============================================================

All ```dplyr``` data manipulations are applied using functions called verbs.

Using these verbs one can apply basic operations on data set provided in data frame, where columns are variables and rows are observations.

These verbs follows SQL-like intuition and thus one can select columns, add condition, transform columns with another function, add new columns and *etc*.

dplyr verbs 2
===========================================================
title: false

Main verbs:

- ```select()``` -- select columns from data frame by their names
- ```filter()``` -- filter data frame by condition on specified columns
- ```arrange()``` -- sort data frame by selected one or more columns
- ```group_by()``` -- group by data frame by specified column
- ```summarise()``` -- summarise multiple values into single 
- ```mutate()``` -- add new column
- ```distinct()``` -- return unique values

First argument in any of these functions is name of data frame!

Other arguments are columns name, conditions, functions and *etc*... We will see by ourselves.

select()
==============================================================

Let say we want to select columns from our data frame ```flights``` -- ```origin``` and ```dest```:


```r
select(flights, origin, dest)
```

However, in some cases we would like to select almost all columns, except a few, though we don't want to write almost all columns name, we rather *deselect* unnecessary. This can be done by specifying minus and column name:


```r
select(flights, -air_time, -distance)
```

**TASK:** select departure and arrival times

filter()
=============================================================

One could imagine as WHERE in SQL, thus if we want data of only February:


```r
filter(flights, month == 2)
```

Furthermore, we are interested only in flights from JFK, hence:


```r
filter(flights, month == 2, origin == "JFK")
```

Let's add March data too:


```r
filter(flights, month == 2 | month == 3, origin == "JFK")
```

**TASK:** select flights from EWR and LGA, which flight more than 1000 miles

arrange()
===========================================================

Arrange allows quickly sort data frame by selected columns. If we give column name as argument, then data will be sorted with increasing values of that column. Let's arrange data by day of month:


```r
arrange(flights, day)
```

However, if we specify minus sign before variable, then data would be sorted in decreasing order:


```r
arrange(flights, -day)
```

If we want to arrange by more columns, just simply add additional column

**TASK:** select data in a way that months will be increase and days will start from the last one

group_by()
==========================================================

Old and faithful ```group by```...

Say, we want to group by airport of destination


```r
group_by(flights, dest)
```

We can group by as many variables as we want:


```r
group_by(flights, origin, dest)
```

Though, group by seems useless yet, but will save us in near future.

**TASK:** group data by hour

summarise()
=======================================================

If we want to evaluate whole column to single value with specified function ```min(), max(), sum()```, *eg*, shortest flight


```r
summarise(flights, min(distance))
```

Or maybe we want shortest and longest flights distance:


```r
summarise(flights, min(distance), max(distance))
```

One should be aware that ```summarise()``` will be most handy when used with ```group_by()```, though be ready.

**TASK:** how much time departure flight was delayed at most and how many miles were flew away at all?

mutate()
===================================================

Sometimes we want to add aggregated variable, for example, duration of flight.

Thus we specify name of new column and then function we would like to apply on other columns:


```r
mutate(flights, duration=arr_time-dep_time)
```

Or we can apply function over existing column and leave it with same name


```r
mutate(flights, dep_delay=abs(dep_delay))
```

**TASK:** add column of average of absolute values of depart and arrival delay time

distinct()
================================================

Works the same as in SQL, though, if we want distinct rows of data frame:


```r
distinct(flights)
```

If we want distinct values of specific column, for example, carrier of flight:


```r
distinct(flights, carrier)
```


**TASK:** select rows with distinct origin of flight.

Pipe operator
===============================================

Pipe operator ```%>%``` allows user to connect or chain set of operations in specified order.

For example, if ```x``` is any kind of data, and ```f()``` is a function we want to apply on data, then it is ```f(x)```. If we want to apply another function ```g()``` on later result, it would be ```g(f(x))``` and so forth.

Using pipe operator, first step could done by ```x %>% f()```. Moreover, if we want to add another function, then it just simple extends to:


```r
x %>% f() %>% g()
```

This chaining with pipe operator alows user simply stream data into pipe and after applying particular functions get the result.

Pipe operator with dplyr
========================================================

Even though we can use ```%>%``` with other functions in R, however especially dplyr functions and use of them becomes more efficient when using pipe operator. 

Why is so?

- dplyr mainly uses indexing by columns, which is more intuitive for user to operate
- we can select few columns of data, then group them by some column, calculate mean, min and max values of groups, then select only unique values and before returning add new column which is aggregated from last result -- in **one line** 
- dplyr is amazingly fast
- if you are not sure why, go back to second bullet point



Pipe operator warning and then... then... then... then...
======================================

The most important thing, is that whem streaming data through pipe, input data at any part of stream should be capable with new option.

Now finally we can go where *shit just gets real*...


If it is hard to imagine pipe operator, then think of it as **then**:

select something **then** group by something **then** summarise **then** filter ...

select something `%>%` group by something `%>%` summarise `%>%` filter ...


Example 1
========================================================

**QUESTION:** In what destination flights from JFK flew on September?


```r
filter(flights, origin == "JFK", month == 9) %>% 
  select(dest) %>%
  distinct()
```


**TASK:** What tail numbers and at what time arrived to ORD airport during the summer on either 5th of 10th day of the month where arrival was delayed for 30 min?


Example 2
========================================================

**QUESTION:** What is a average distance of flights flew from different airports for second half year of 2013?


```r
filter(flights, month >= 6) %>%
  group_by(origin) %>%
  summarise(avg.distance = mean(distance))
```

**TASK:** How much did each carrier's planes, that flew from JFK to ATL, spend time on air (air_time) at all during last month of the year?

Example 3
=======================================================

There are some NA's in data, remove them by:


```r
flights <- na.omit(flights)
```

**QUESTION:** What is average minute of departure of each month? Then please convert this value to seconds and sort by months in descending order


```r
group_by(flights, month) %>%
  summarise(avgMinute = mean(minute)) %>%
  mutate(avgMinuteInSeconds = avgMinute * 60) %>%
  arrange(-month)
```
  
**TASK:** What is average hour of departure (hour) and average minute of departure (minute) from each origin airports and what is absolute differences of average hours and average minutes? Sort final table by average minute of departure in ascending order


Level up!
=======================================================

From Janitor to Efficient Janitor !



Time to practise more, Janitors !

***

![alt text](level-up.gif)

Homework data set
=======================================================

Use classical motor trend car road test data set.

This is data set from magazine published 1974.


```r
library(datasets)
data(mtcars)
```

More about data set could be found:


```r
?mtcars
```

Homework tasks
=======================================================

**TASK 1:** What is average horsepower accross cars with different number of cylinders? Sort by descending order of average horsepower.

**TASK 2:** How much do cars with automatic transmission weights at most by different number of carburetors?

**TASK 3:** Additionally calculate horsepower per mpg and take square root of that number, call this metric as `hpmpg`. Then select only those cars which this metric `hpmpg` is larger than 4. Finally, select leave only mpg and hp

**TASK 4:** Make groups by number of cylinders, transmission type and number of gears, then calculate mean of each group. Then again make groups just by number cylinders and transmission type and take minimum average of mpg across these groups

**TASK 5:** I don't care about any other cars parameters, expect quater mile time and horsepower, because I do not understand anything else. Return me a table of these parameters that in top it would be the best cars by later two parameters and in the bottom -- the worse. Hint: I would prefer cars with bigger horsepower

