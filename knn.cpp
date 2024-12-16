// Implement batch computation of Euclidean distances using Rcpp.
#include <Rcpp.h>    //Used for data interaction between R and C++
#include <cmath>     //Used for mathematical operations (e.g., `std::pow`)
#include <algorithm> //Used for sorting and selection (e.g., `nth_element`)
#include <map>       //Used for key-value pair storage (e.g., label voting)
#include <numeric>   //Used for numerical computations (e.g., `iota`)
using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector knn_euclidean_optimized(NumericMatrix train_data,
    NumericVector train_sq,
    IntegerVector train_labels,
    NumericMatrix test_data,
    int k) {
    // Get the dimensions of the training and test sets
    int n_test = test_data.nrow();
    int n_train = train_data.nrow();
    int n_features = train_data.ncol();

    // Initialize a vector to store prediction results with a length equal to the number of test set samples
    IntegerVector predictions(n_test); 

    // Iterate through each test sample
    for (int i = 0; i < n_test; i++) {
        // Store the distances between the current test sample and all training samples
        NumericVector distances(n_train);  

        // Compute the squared sum of the current test sample (for optimized distance calculation)
        double test_sq = 0.0;
        for (int d = 0; d < n_features; d++) {
            test_sq += std::pow(test_data(i, d), 2);
        }

        // Calculate the Euclidean distance
        for (int j = 0; j < n_train; j++) {
            double dot_product = 0.0;
            for (int d = 0; d < n_features; d++) {
                 // Compute the dot product (test sample * corresponding feature values of training samples)
                dot_product += test_data(i, d) * train_data(j, d);  
            }
            // Use the properties of squared sums to optimize the calculation of Euclidean distances
            distances[j] = train_sq[j] + test_sq - 2.0 * dot_product;
        }

        // Retrieve the indices of the top k nearest neighbors
        std::vector<int> indices(n_train);

        // Initialize as 0, 1, ..., n_train-1
        std::iota(indices.begin(), indices.end(), 0); 

        // `nth_element` places the indices of the k smallest distances in the first k positions
        std::nth_element(indices.begin(), indices.begin() + k, indices.end(),
            [&distances](int a, int b) { return distances[a] < distances[b]; });

        // Label voting for the nearest neighbors
        std::map<int, int> label_count;
        for (int m = 0; m < k; m++) {
            // Retrieve the labels of the nearest neighbors
            int neighbor_label = train_labels[indices[m]];  
            label_count[neighbor_label]++;                  
        }

        // Find the label with the highest number of votes
        int best_label = -1, max_count = 0;
        for (auto& it : label_count) {
            if (it.second > max_count) {
                best_label = it.first;
                max_count = it.second;
            }
        }

        predictions[i] = best_label;     }

    return predictions;
}