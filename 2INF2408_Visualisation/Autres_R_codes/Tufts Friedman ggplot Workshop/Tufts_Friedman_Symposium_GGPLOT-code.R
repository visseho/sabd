
  ## title: "ggplot2::workshop(...)"

  #### Tufts Friedman Symposium 2021
  ##### written by: M.A. Hartwick
  
  
  
  ## Set up the environment
  ##### (check if tidyverse installed)

packages <- c("tidyverse", "skimr", "RColorBrewer")
install.packages(setdiff(packages, rownames(installed.packages())))

library(tidyverse)
library(skimr)
library(RColorBrewer)
search()

## 1. Data

iris[1:20,]

### Data Structure (tidyverse)


iris %>%
  skimr::skim()

### tidyverse
#### (data cleaning)


set.seed(100)
iris_clean <- iris %>% 
  mutate(Trial = sample(3, n(), replace = TRUE))

iris_clean %>% skim()

## 2. Function

iris_clean %>%
  ggplot()

## 3. Coordinates

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length ))

## 4. Mapping

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Width, color = Species))

## 5. Geometries

#### geom_histogram(...), geom_point(...), geom_bar(...), geom_col(...)
##### - geom_histogram(...) is a count geom, so only takes one coordinate

iris_clean %>% 
  ggplot(.,aes(x = Sepal.Length, color = Species)) +
  geom_histogram()

##### - color sets the outline here, what happens if we try fill instead?
##### - what happens when we specify bin size?
##### - where should that argument go?

iris_clean %>% 
  ggplot(.,aes(x = Sepal.Length, fill = Species)) +
  geom_histogram()

##### - The geom 'fill' is specified
##### - Add an outline and transparency outside the mapping.
##### - Could we specify the fill aesthetic inside the geom_histogram?, how?

iris_clean %>% 
  ggplot(.,aes(x = Sepal.Length, fill = Species)) +
  geom_histogram(aes(color = Species), alpha = 0.4)


##### - Try out geom_point with an x and y coordinate.
##### - What happens if we remove the 'as.character()' wrapper from Trial?

iris_clean %>% 
  ggplot(.,aes(x = Sepal.Width, y = Sepal.Length, color = Species,
               shape = as.character(Trial))) +
  geom_point()

##### - Let's try a barchart with x and y coordinates, mapped to species.
##### - The default for geom_barchart(...) is count (similiar to geom_histogram(...)).
##### - What happens if we remove stat = 'identity'?

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_bar(stat = 'identity')


##### - geom_col(...) is the geometry for x and y barcharts.
##### - The default here is stat = 'identity', so no need to specify.

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col()


##### - By changing position from the default 'stacked' to dodge we can look at the 
#####   species as separate columns.

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge')

##### - Before we move on to the next layer, is there another geom_* you want to try?
##### - Add your own geom_* below from some that we've discussed (boxplot, violin?)
##### - What have we learned about default arguments that could help here
##### - Remember to run '?geom_*()' to find defaults.

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species))

## 6. Scales

#### scale_y_continous(...), scale_x_discrete(...), scale_color_manual(...), scale_color_brewer(...)
##### - Let's adjust the breaks in the y axis for each major break.
##### - The data are continous so we use scale_y_continouus(...).

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') +
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8))

##### - Let's also expand the x-axis so the data fills the plotting area.
##### - Remember, at this point the Trial data is still datatype continous,
##### - So we use: scale_x_continous(...)
##### - What happens if we use scale_x_discrete(...)

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') +
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01))

##### - Want to apply scales to some other attributes?
##### - Lets add another layer of geom below and adjust that.
##### - what are some other things we could do to improve this? (keep in mind for later)
##### - What happens if we change the order of the geoms_*(...)?

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = Trial), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23))

##### - Time to adjust the default colors.
##### - First let's take a look at the basic Rcolors
colors()

##### - First we'll try to manually set our selected colors with scale_color_manual(...)
##### - That changed something, but what?
##### - What's going on with our data that Trial is continous
##### - and it didn't use the colors argument?

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) +
  scale_color_manual(values = c('plum2', 'lemonchiffon', 'skyblue3'))

##### - Let's try using scale_fill_manual(...) to map to Species, which is character class
##### - Then, we'll wrap Trial in as.character, add a scale_color_manual(...)
##### - Why are we using both fill and color scales here? (hint: think back to
##### - geom_histogram(...))

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)),
             position =position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) +
  scale_fill_manual(values = c('plum2', 'lemonchiffon', 'skyblue3'))+
  scale_color_manual(values = c('forestgreen', 'grey80', 'aquamarine2'))


#### What do some of the Pre-Built color scales look like?

display.brewer.all()

##### - Let's take RcolorBrewer for a spin

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3')


## 7. Facets

#### facet_wrap(...), facet_grid(...)
##### - Start off with facet_wrap(...) by Trial.
##### - What happens with the x-axis?

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3') +
  facet_wrap(~Trial)

##### - Adjust the x-axis scale
##### - Lets view by rows instead of columns and move the facet labels

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3') +
  facet_wrap(~Trial, scales = "free_x", nrow = 3, strip.position = 'right')

##### - Facet_grid(...) is similiar, is there any varaible that we should look at
##### - Adjust the code below and add another varaible to the before the '~', what happens?

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3') +
  facet_wrap(~Trial, scales = "free_x", nrow = 3, strip.position = 'right')

## 8. Themes

##### - Start by adding some Pre-Built themes.
##### - What other Pre-Built themes are availble, start typing 'theme' in the console below.
##### - What pops up? What are their defaults? 

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3') +
  facet_wrap(~Trial, scales = "free_x", nrow = 3, strip.position = 'right') +
  theme_minimal()


##### - Let's try out setting some of the elements ourselves.
##### - What else would you adjust?

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3') +
  facet_wrap(~Trial, scales = "free_x", nrow = 3, strip.position = 'right')+
  theme(legend.text = element_text(face = 'bold'),
        text = element_text(family = 'mono', color = 'grey7', size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = 'grey10'))

## From Sketch to Story, your turn:

#### Challenge(No Hints)
####### -Facetted Width and Length
####### -Bargraph
####### -Trial axis breaks as '2010', 2015', '2020'
####### -Y axis at 2, 4, 6, 8
####### -Ditch the points, and accomponying scale
####### -Choose a different palette for species
####### -Dodge position
####### -Species in italics
####### -No grey in facet
####### -Use a more elegant font

iris_clean %>%
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + 
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + 
  scale_shape_manual(values = c(21,22,23)) + 
  scale_fill_brewer(palette = 'Set2') +
  scale_color_brewer(palette = 'Set3') +
  facet_wrap(~Trial, scales = "free_x", nrow = 3, strip.position = 'right')+
  theme(legend.text = element_text(face = 'bold'),
        text = element_text(family = 'mono', color = 'grey7', size = 10),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = 'grey10'))


#### Challenge(Hints)
####### -Faceted Width and Length - add a tidyr::pivot_longer(...) pipe before ggplot2::
####### -Bargraph - choose the best option from the geoms we covered
####### -Trial axis breaks as 2010, 2015, 2020 - transform Trial column to character,use scale*
####### -Y axis at 2, 4, 6, 8 - Modify existing scale*
####### -Ditch the points, and accomponying scale - delete the correct geom_*()
####### -Choose the correct scale and change color palette - Modify Existing Scale*
####### -Dodge position - set from in geom*
####### -Species in italics - modify the theme
####### -No grey in facet - modify the theme
####### -Use a more elegant font - modify the theme, solution uses a different package


iris_clean %>% # Faceted Width and Length - add a tidyr::pivot_longer(...) %>%
  #Trial axis breaks as 2010, 2015, 2020 - transform Trial column to character
  # mutate(Trial = as.character(Trial))
  ggplot(.,aes(x = Trial, y = Sepal.Length, fill = Species)) +
  geom_col(position = 'dodge') + # Bargraph and Dodge - choose the best option from the geoms we covered
  geom_point(aes(shape = Species, color = as.character(Trial)), position = position_dodge(width = 1))+ # delete the points geom
  scale_y_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  scale_x_continuous(expand = c(0.01,0.01)) + #Trial axis breaks as 2010, 2015, 2020, change scale*
  scale_shape_manual(values = c(21,22,23)) + # geom_point() scale, delete
  scale_fill_brewer(palette = 'Set2') + #change this palette
  scale_color_brewer(palette = 'Set3') + #delete this scale, was for points
  facet_wrap(~Trial, scales = "free_x", nrow = 3, strip.position = 'right')+
  theme(legend.text = element_text(face = 'bold'), #Species in italics - modify the theme
        text = element_text(family = 'mono', color = 'grey7', size = 10),# Use a more elegant         font - modify the theme,
        #No grey in facet - modify the theme
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = 'grey10'))


### Solution
####### -Facetted Width and Length - add a tidyr::pivot_longer(...) pipe before ggplot2::
####### -Bargraph - choose the best option from the geoms we covered
####### -Trial axis breaks as 2010, 2015, 2020 - transform Trial column to character,use scale*
####### -Y axis at 2, 4, 6, 8 - Modify existing scale*
####### -Ditch the points, and accomponying scale - delete the correct geom_*()
####### -Choose the correct scale and change color palette - Modify Existing Scale*
####### -Dodge position - set from in geom*
####### -Species in italics - modify the theme
####### -No grey in facet - modify the theme
####### -Use a more elegant font - modify the theme, solution uses a different package


#library(extrafont)
iris_clean %>% tidyr::pivot_longer(cols = c('Petal.Length', 'Petal.Width'),
                                   names_to = 'Petal_Attribute',
                                   values_to = 'Petal_Measurement') %>%
  dplyr::mutate(Trial = as.character(Trial)) %>% 
  ggplot(.,aes(x = Trial, y = Petal_Measurement, fill = Species)) +
  geom_col(position = 'dodge') +
  scale_y_continuous(breaks = c(2,4,6,8,10,12,14), expand = c(0,0), limits = c(0, 15)) +
  scale_x_discrete(breaks = c(1,2,3),
                   labels = c('2010', '2015', '2020')) +
  scale_fill_manual(values = c("skyblue3", "peachpuff", 'mediumaquamarine')) +
  scale_color_manual(values = c("skyblue3", "peachpuff", 'mediumaquamarine')) +
  facet_wrap(~Petal_Attribute,
             scales = 'free',
             ncol = 2, strip.position = 'top')+
  theme(legend.text = element_text(face = 'italic'),
        text = element_text(color = 'grey7',
                            size = 10),
        #family = 'Palatino Linotype'
        strip.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(colour = 'grey10')) +
  ylab('Petal Measurement')

## end(...)



