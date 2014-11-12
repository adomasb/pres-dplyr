# Solution 1
filter(flights, day == 5 | day == 10, dest== "ORD", month %in% c(6,7,8), arr_delay >= 30) %>%
  select(tailnum, arr_time)

# Solution 2
filter(flights, origin == "JFK", dest == "ATL", month == 12) %>%
  group_by(carrier) %>%
  summarise(time.spent = sum(air_time))

# Solution 3
group_by(flights,  origin) %>%
  summarise(avgHour = mean(hour), avgMinute = mean(minute)) %>%
  mutate(absDiff = abs(avgHour - avgMinute))

### Homework solution

# 1
group_by(mtcars, cyl) %>%
  summarise(avgHP = mean(hp)) %>%
  arrange(-avgHP)

# 2
filter(mtcars, am == 0) %>%
  group_by(carb) %>%
  summarise(maxWT = max(wt)) %>%
  arrange(-maxWT)

# 3
mutate(mtcars, hpmpg = hp/mpg) %>%
  mutate(hpmpg = sqrt(hpmpg)) %>%
  filter(hpmpg > 4) %>%
  select(mpg, hp)

# 4
group_by(mtcars, cyl, am, gear) %>%
  summarise(avgMpg = mean(mpg)) %>%
  group_by(cyl, am) %>%
  summarise(min(avgMpg))

# 5
select(mtcars, qsec, hp) %>%
  arrange(-hp, -qsec)
