#include <fstream>

using namespace std;

ifstream in("sudoku.in");
ofstream out("sudoku.out");

int a[10][10];
bool done;

void afis()
{
    for(int i = 0; i < 9; ++i)
    {
        for(int j = 0; j < 9; ++j)
            out << a[i][j] << " ";
        out << '\n';
    }
}

bool valid(int x, int y, int p)
{
    for(int i = 0; i < 9; ++i)
        if(a[i][y] == p || a[x][i] == p)
            return false;
    int i = 3 * (x / 3);
    int j = 3 * (y / 3);
    for(int ii = i; ii <= i + 2; ++ii)
        for(int jj = j; jj <= j + 2; ++jj)
            if(a[ii][jj] == p)
                return false;
    return true;
}

void bt(int k)
{
    if(!done)
        if(k >= 81)
        {
            afis();
            done = 1;
        }
        else
        {
            int i = k / 9;
            int j = k % 9;
            if(a[i][j])
                bt(k + 1);
            else
                for(int p = 1; p <= 9; ++p)
                    if(valid(i,j,p))
                    {
                        a[i][j] = p;
                        bt(k + 1);
                        a[i][j] = 0;
                    }
        }
}

int main()
{
    for(int i = 0; i < 9; ++i)
        for(int j = 0; j < 9; ++j)
            in >> a[i][j];
    bt(0);
    if(!done)
        out << -1;
    return 0;
}
