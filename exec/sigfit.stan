functions {
    vector scale_to_sum_1(vector v) {
        return (v / sum(v));
    }
}
data {
    int<lower=1> C; // number of categories
    int<lower=1> S; // number of signatures
    int<lower=1> G; // number of genomes
    matrix[C, S] signatures; // matrix of categories (rows) by signatures (columns)
    int counts[G, C]; // data = counts per category (columns) per genome sample (rows)
    vector<lower=0>[S] alpha; // prior on probs
}
parameters {
    simplex[S] exposures;
    simplex[C] probs;
}
model {
    probs = scale_to_sum_1(signatures * exposures);
    exposures ~ dirichlet(alpha);
    for (i in 1:G) {
      counts[i] ~ multinomial(probs);
    }
}
