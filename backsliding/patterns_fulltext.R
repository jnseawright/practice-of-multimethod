


pattern_wil <- "(?=Downloaded from ).*?(?<=governed by the applicable Creative Commons License)"
pattern_an_1 <- "Downloaded from www.annualreviews.org"
pattern_an_2<-  "(?=Access provided by \\d+\\.\\d+\\.\\d+\\.\\d+).{0,200}(?<=For personal use only.)"
pattern_jstor_1 <- "(?=This content downloaded from).*?(?<=org/terms)"
pattern_jstor_2 <- "(?=This content downloaded from \\d+\\.\\d+\\.\\d+\\.\\d+)(\\\n|.){0,200}(Conditions)"
pattern_jstor_3 <- "(?=This content downloaded from)(.|\\n){0,300}(?<=org/terms)"

pattern_other <- "(?=Downloaded by \\[).*?(?<=\\d{4})"
pattern_oup_1 <- "(?=Downloaded from https://academic.ou).*?on\\s\\d{2}\\s\\w+?\\s\\d{4}"
pattern_oup_2 <- "(?=Downloaded from http://pan.oxfordjournals).*?on\\s.*?,\\s\\d{4}" 
pattern_cambridge <- "(Downloaded from https://www.cambridge).*?(terms.)"
pattern_soc <- "(?=Downloaded from soc.sagep).*?on\\s.*?,\\s\\d{4}"
pattern_sf <- "(?=Downloaded from http://sf.oxfor).*?on\\s.*?,\\s\\d{4}"
pattern_poq <- "(?=Downloaded from http://poq.ox).*?on\\s.*?,\\s\\d{4}"

pattern_sum <- paste(pattern_wil, pattern_an_2, pattern_an_1, pattern_jstor_1, pattern_jstor_2,
                     pattern_other, pattern_oup_1, pattern_oup_2, pattern_cambridge, 
                     pattern_soc, pattern_sf,pattern_poq, sep = "|")


# Other Strings I've identified after removing the above
# we will have to specify 'fixed' in the string replace/remove because these unique strings aren't valid regex

#patterns_unique_1 <- "Downloaded from http://socpro.oxfordjournals.org/ by guest on January 8 , 2016 ts a oe a Sesselppy ejeuixoiddy @ 9 oor Sal OOL os Sz 0 sasselppy oyI9eds oO I 09 uoyes07 AIEY W : OZ T 08 6 ¢ Ov 8 0c 2 , SE = 42 , sae } uUaseald SByIW siajjng sapiya ) e < e uosaqoy e ured | ) vosdu gl ss uaAesD ie a 3"
#patterns_unique_2 <-  "This article was downloaded by : [ McGill University Library ] On : 08 October 2014 , At : 08 : 21 "
#patterns_unique_3 <-  "Fascism and Populism : Are They Useful Categories for Comparative Sociological Analysis Mabel Berezin Annual Review of Sociology Cite this paper Downloaded from Academia.eduY Get the citation in MLA , APA , or Chicago styles Related papers Download a PDF Pack of the best related papers % Mueller A ( 2019 ) The Meaning of Populism Axel Mueller Political Theory of Populism Nadia Urbinat ! Do we need a minimum definition of populism ? An appraisal of Mudde's conceptualization Oscar Mazzoleni Annu . Rev . Sociol . 2019.45 .   SO45CH18_Berezin ARjats.cls_ = April 24 , 2019 Lay ANNUAL iii REVIEWS Annu . Rev . Sociol . 2019 . 45 : 18.1-18.17 The Annual Review of Sociology is online at soc.annualreviews.org https://doi.org/10.1146/annurev-soc-073018- 022351 Copyright © 2019 by Annual Reviews . All rights reserved 13 : 56 Annual Review of Sociology Fascism and Populism : Are They Useful Categories for Comparative Sociological Analysis ? Mabel Berezin Department of Sociology , Cornell University , Ithaca , New York 14853 , USA ; email : mmb39@cornell.edu Keywords fascism , populism , extremism , radical right , nationalism Abstract"
#patterns_unique_4 <- "content downloaded from 128.122.253.212 on Fri , 13 Feb 2015 03 : 55 : 20 AM All use subject to JSTOR Terms and Conditions"
#patterns_unique_5 <- "content downloaded from 128.235.251.160 on Fri , 26 Dec 2014 20 : 40 : 09 PM All use subject to JSTOR Terms and Conditions"
patterns_unique_6 <- "This content downloaded from129.105.215.146 on Fri, 28 Oct 2022 12:25:35 UTCAll use subject to https://about.jstor.org/terms"


