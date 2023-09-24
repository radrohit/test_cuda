#include <thrust/device_vector.h>
#include <thrust/transform.h>
#include <thrust/sequence.h>
#include <thrust/copy.h>
#include <thrust/fill.h>
#include <thrust/replace.h>
#include <thrust/functional.h>
#include <iostream>


// square<T> computes the square of a number f(x) -> x*x
template <typename T>
struct square
{
    __host__ __device__
        T operator()(const T& x) const {
            return x * x;
        }
};

template <typename T>
struct subtract_square
{
    __host__ __device__
        T operator() (const T& x, const T &y) const {
            return (x - y) * (x-y);
        }
};



int main(void)
{
    // allocate three device_vectors with 10 elements
    thrust::device_vector<int> X(10);
    thrust::device_vector<int> Y(10);
    thrust::device_vector<int> Z(10);

    // initialize X to 0,1,2,3, ....
    thrust::sequence(X.begin(), X.end());

    // initialize Y to 0,1,2,3 ...
    //thrust::sequence(Y.begin(), Y.end());
    thrust::fill(Y.begin(),Y.end(),2);

    //computeY=-X
    //thrust::transform(X.begin(),X.end(),Y.begin(),thrust::negate<int>());

    //square<int> sq_op;
    //thrust::minus<float> minus_op;


    // compute Y = -X
    //thrust::transform(X.begin(), X.end(), Y.begin(), Z.begin(), thrust::minus<int>());
    int init = 0;
    thrust::transform(X.begin(), X.end(), Y.begin(), Z.begin(), subtract_square<int>());
    float distance = thrust::reduce(Z.begin(), Z.end(), init, thrust::plus<int>());
    // fill Z with twos
    //thrust::fill(Z.begin(), Z.end(), 2);

    // compute Y = X mod 2
    //thrust::transform(X.begin(), X.end(), Z.begin(), Y.begin(), thrust::modulus<int>());

    // replace all the ones in Y with tens
    //thrust::replace(Y.begin(), Y.end(), 1, 10);

    // print Y
    thrust::copy(X.begin(), X.end(), std::ostream_iterator<int>(std::cout, "\n"));
    thrust::copy(Y.begin(), Y.end(), std::ostream_iterator<int>(std::cout, "\n"));
    thrust::copy(Z.begin(), Z.end(), std::ostream_iterator<int>(std::cout, "\n"));
    std::cout << "Distance is " << distance << std::endl;
    return 0;
}
