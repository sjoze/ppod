import pandas as pd
from anonymizedf.anonymizedf import anonymize
import friendlywords as fw
import numpy as np
import random

random.seed(48)


def pseudonymize(dataframe, column):
    an = anonymize(dataframe)
    an.fake_names(column)
    dataframe.rename(columns={"Fake_name": "pseudo_name"}, inplace=True)
    return dataframe


def randomize(dataframe, column, type):
    # smaller list size for a fair amount of overlapping
    list_size = round(0.67 * dataframe[column].nunique())
    friendly_list = [fw.generate(type) for x in range(0, list_size)]
    df_length = len(dataframe[column])
    dataframe["rand_" + column] = pd.Series([friendly_list[hash(x)%len(friendly_list)] for x in range(0, df_length)], index=dataframe.index)

    # create lookup tables and save as csv
    unique_values = dataframe[column].unique()
    lookup_values = []
    for value in unique_values:
        lookup_values.append(friendly_list[hash(value)%len(friendly_list)])

    pd.DataFrame(list(zip(unique_values, lookup_values)),
                      columns=[column, "lookup"]).to_csv("data/"+ column +"_lookup.csv")

    return dataframe


def aggregate(dataframe, column, bins):
    bins = pd.IntervalIndex.from_tuples(bins)
    dataframe[column + "_bins"] = pd.cut(dataframe[column].to_numpy(), bins)
    return dataframe


def distort(dataframe, column, sd):
    # use standard deviation as measure for noise
    dataframe[column + "_distorted"] = pd.Series([x + round(np.random.normal(0, sd)) for x in dataframe[column]])
    return dataframe


def main():

    # read in athletes dataset
    data = pd.read_csv("data/athletes.csv")

    # Apply pseudonymization, randomization, aggregation and distortion
    data = pseudonymize(data, "name")

    data = randomize(data, "region", "po")
    data = randomize(data, "affiliate", "po")
    data = randomize(data, "team", "pt")
    data = aggregate(data, "age",
                     [(0, 10), (20, 30), (30, 40), (40, 50), (50, 60), (60, 70), (70, 80), (80, 90), (90, 130)])
    data = distort(data, "height", 3.987973)    # sd as derived from R script
    data = distort(data, "weight", 34.21625)    # -""-

    # delete original columns
    data = data.drop(columns=["name", "region", "affiliate", "team", "age", "height", "weight"])

    # save altered dataset
    data.to_csv('data/anonymized_athletes.csv')


if __name__ == "__main__":
    main()
