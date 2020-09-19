#include <iostream>
#include <array>


constexpr int cofactor(int i, int j)
{
    return (i + j) % 2 ? 1 : -1;
}

template<std::size_t N>
constexpr auto minor(const std::array<std::array<int, N>, N>& a, int i, int j)
{
    std::array<std::array<int, N - 1>, N - 1> r{};
    for (int ii = 0; ii != N - 1; ++ii)
        for (int jj = 0; jj != N - 1; ++jj)
            r[ii][jj] = a[ii + (ii >= i ? 1 : 0)][jj + (jj >= j ? 1 : 0)];
    return r;
}

template <int N>
constexpr int det(const std::array<std::array<int, N>, N>& a)
{
    int d = 0;

    for (int i = 0; i < N; ++i)
        for (int j = 0; j != N; ++j)
            d += cofactor(i, 1) * a[i][0] * det<N-1>(minor(a, i, j));

    return d;
}

template <>
constexpr int det<2>(const std::array<std::array<int, 2>, 2>& a)
{
    return a[0][0] * a[1][1] - a[0][1] * a[1][0];
}

template <>
constexpr int det<1>(const std::array<std::array<int, 1>, 1>& a)
{
    return a[0][0];
}

int main()
{
    std::array<std::array<int, 3>, 3> A = {{
        {0, 1, 2},
        {1, 2, 3},
        {2, 3, 7}
    }};
    auto res = det<3>(A);
    std::cout << res << "\n";
    return 0;
}
