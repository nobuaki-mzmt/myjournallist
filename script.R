library(data.table)
library(dplyr)

mylist = c("Nature","Science","Annual Review of Entomology","Trends in Ecology & Evolution",
           "Nature Ecology & Evolution","Nature Communications","Science Advances",
           "PROCEEDINGS OF THE NATIONAL ACADEMY OF SCIENCES OF THE UNITED STATES OF AMERICA","Current Biology","Ecology Letters",
           "Physical Review Letters","eLife","Plos Biology","Methods in Ecology and Evolution",
           "BMC Biology","Communications Biology","Philosophical Transactions of the Royal Society B-Biological Sciences",
           "Functional Ecology","Ecology","PROCEEDINGS OF THE ROYAL SOCIETY B-BIOLOGICAL SCIENCES","Evolution Letters",
           "Current Opinion in Insect Science","Journal of Animal Ecology","Plos Computational Biology",
           "Scientific Reports","Frontiers in Ecology and Evolution","Journal of the Royal Society Interface",
           "American Naturalist","Interface Focus","Oikos","Heredity","Biology Letters","Evolution",
           "Movement Ecology","Journal of Eukaryotic Microbiology","Journal of Experimental Biology",
           "Insect Science","BMC Evolutionary Biology","PLoS ONE","Oecologia","Journal of Biological Rhythms",
           "Evolutionary Biology","European Journal of Protistology","PeerJ","Behavioral Ecology and Sociobiology",
           "Ecological Modelling","BMC Ecology","Royal Society Open Science","Ecology and Evolution",
           "Animal Behaviour","Insects","Evolutionary Ecology","Journal of Theoretical Biology",
           "Behavioral Ecology","Journal of Chemical Ecology","Current Zoology","Physical Review E",
           "Ecological Entomology","Biology Open","Journal of Evolutionary Biology",
           "Journal of Economic Entomology","Journal of Insect Physiology",
           "Entomologia Experimentalis Et Applicata","Swarm Intelligence",
           "Biological Journal of the Linnean Society","Population Ecology",
           "Annals of the Entomological Society of America","Science of Nature",
           "Ecological Research","Ethology","Ecological Complexity",
           "Journal of insect Science","Journal of Comparative Physiology A-NEUROETHOLOGY SENSORY NEURAL AND BEHAVI",
           "Physiological Entomology","Behavioural Processes","Bulletin of Entomological Research",
           "Insectes Sociaux","Entomological Science","European Physical Journal B","Applied Entomology and Zoology",
           "Ethology Ecology & Evolution","Journal of Insect Behavior","Journal of Ethology","Biological Rhythm Research",
           "Sociobiology","Artificial Life","Artificial Life and Robotics","Zoological Letters",
           "Molecular Phylogenetics and Evolution","Environmental Entomology",
           "iScience", "Physiological Entomology", "STAR Protocols", "Southeastern Naturalist",
           "Journal of Pest Science", "Biological Invasions", "Zoological Letters")


mylist.Up <- toupper(mylist)

# 2025
df    <- data.frame(fread("2025/jif.csv", header=T))
df <- df |> filter(!is.na(IF)) |>
  mutate(
    journalname =  toupper(journalname),
    IF = as.numeric(IF)) |>
  group_by(journalname) |>
  summarise(IF = mean(IF, na.rm = T), .groups = "drop") |>
  na.omit()

df <- df |> filter(journalname %in% mylist.Up)

write.csv(df, file = file.path(2025,"2025-ifs.csv"))
df |> filter(str_detect(journalname, "RHYTHM" ))

###

iodir <- "2025"
file.list = list.files(iodir, pattern=".csv")

df <- NULL
for(i in file.list){
  d.temp    <- data.frame(fread(file.path(iodir, i), header=T))
  temp.name <- toupper(d.temp$Journal.name)
  d.temp    <- d.temp[temp.name %in% mylist.Up, c("Journal.name", "JIF")]
  df        <- rbind(df, d.temp)
}

df <- df[!duplicated(df),]
df$JIF <- as.numeric(df$JIF)
df <- df[order(df$JIF, decreasing = T),]

write.csv(df, file = file.path(iodir,"2023-ifs.csv"))



file.list = list.files(iodir, pattern="Others.csv")

df <- NULL
for(i in file.list){
  d.temp    <- data.frame(fread(file.path(iodir, i), header=T))
  temp.name <- toupper(d.temp$Journal.name)
  d.temp    <- d.temp[temp.name %in% mylist.Up, c("Journal.name", "X2022.JIF")]
  df        <- rbind(df, d.temp)
}

df <- df[!duplicated(df),]
df$X2022.JIF <- as.numeric(df$X2022.JIF)
df <- df[order(df$X2022.JIF, decreasing = T),]

write.csv(df, file = file.path(iodir,"2023-others.csv"))
