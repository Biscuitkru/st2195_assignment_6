# st2195_assignment_6

Download the ECB speeches dataset and the daily EUR/USD reference exchange rate from the ECB Statistical Data Warehouse. https://sdw.ecb.europa.eu/browse.do?node=9691296
Next, save them as “speeches.csv” and “fx.csv”. For the speeches.csv, please keep only the “date” and “contents” columns.

1. Load and merge the datasets keeping all information available for the dates in which there is a measurement in “fx.csv”. 
 
2. Remove entries with obvious outliers or mistakes, if any. 

3. Handle missing observations for the exchange rate, if any. This should be done replacing any missing exchange rate with the latest information available. Whenever this cannot be done, the relevant entry should be removed entirely from the dataset.

4. Calculate the exchange rate return. Extend the original dataset with the following variables: “good_news” (equal to 1 when the exchange rate return is larger than 0.5 percent, 0 otherwise) and “bad_news” (equal to 1 when the exchange rate return is lower than -0.5 percent, 0 otherwise).

5. Remove the entries for which contents column has NA values. Generate and store in csv the following tables:
a. “good_indicators” – with the 20 most common words (excluding articles, prepositions and similar connectors) associated with entries wherein “good_news” is equal to 1;
b. “bad_indicators” – with the 20 most common words (excluding articles,prepositions and similar connectors) associated with entries wherein “bad_news” is equal to 1;
Any observation from the common words found above?
