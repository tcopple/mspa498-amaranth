library(choroplethr)
data(df_pop_state)
brfss2015 = brfss2015[!is.na(brfss2015$FLUSHOT6),]
brfss2015$region = df_pop_state[match(brfss2015$X_STATE, as.numeric(rownames(df_pop_state))),1]
choro_map = data.frame(table(brfss2015$region))
colnames(choro_map)[1] = "region"
colnames(choro_map)[2] = "value"
state_choropleth(choro_map)
