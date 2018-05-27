my_ui <- fluidPage {
  
   # Just my code for the select box, once merged put it in the appropriate spot
   selectInpud("select", label = h3("Genre"),
               choices = list("Electronic" = 1, "Experimental" = 2, "Folk and Country" = 3, "Global (int'l. music)" = 4, "Jazz" = 5,
                              "Metal" = 6, "Pop" = 7,"Rap" = 8, "Rock" = 9, "Undefined (No genre labeled)" = 10),
               selected = 7
               )
}